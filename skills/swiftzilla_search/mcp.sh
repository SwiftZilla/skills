#!/bin/bash
# A pure Bash MCP Client using curl and jq

API_URL="${SWIFTZILLA_API_URL:-https://swiftzilla.dev}"
API_KEY="${SWIFTZILLA_API_KEY}"

if [ -z "$API_KEY" ]; then
    echo "Error: SWIFTZILLA_API_KEY is not set" >&2
    exit 1
fi

# Temp files
SSE_OUT=$(mktemp)
HEADERS_FILE=$(mktemp)
RESPONSE_FILE=$(mktemp)

cleanup() {
    # Kill background curl if running
    if [ -n "$CURL_PID" ]; then kill "$CURL_PID" 2>/dev/null; fi
    rm -f "$SSE_OUT" "$HEADERS_FILE" "$RESPONSE_FILE"
}
trap cleanup EXIT

# 1. Start SSE Stream in background (using header auth)
# We use -N (no buffer) and send API key as header
curl -N -s "${API_URL}/mcp/sse" \
    -H "X-API-Key: ${API_KEY}" > "$SSE_OUT" &
CURL_PID=$!

# 2. Wait for Session ID (endpoint event)
SESSION_ENDPOINT=""
MAX_RETRIES=20
COUNT=0

while [ $COUNT -lt $MAX_RETRIES ]; do
    if grep -q "event: endpoint" "$SSE_OUT"; then
        # Extract data line after event: endpoint
        # grep -A 1 "event: endpoint" | grep "data:"
        RAW_DATA=$(grep -A 1 "event: endpoint" "$SSE_OUT" | grep "data:" | head -n1)
        # remove "data: " prefix
        SESSION_ENDPOINT=$(echo "$RAW_DATA" | sed 's/data: //g' | tr -d '\r')
        break
    fi
    sleep 0.2
    COUNT=$((COUNT+1))
done

if [ -z "$SESSION_ENDPOINT" ]; then
    echo "Error: Could not connect to MCP Session (Timeout waiting for handshake)" >&2
    cat "$SSE_OUT" >&2
    exit 1
fi

# normalize endpoint: if relative, prepend API_URL
if [[ "$SESSION_ENDPOINT" != http* ]]; then
    # ensure API_URL doesn't have trailing slash and endpoint starts with slash logic handled
    # assuming behavior
    FULL_POST_URL="${API_URL}${SESSION_ENDPOINT}"
else
    FULL_POST_URL="$SESSION_ENDPOINT"
fi

# 3. Send Initialize with API Key header
# ID 0
curl -s -X POST "${FULL_POST_URL}" \
    -H "Content-Type: application/json" \
    -H "X-API-Key: ${API_KEY}" \
    -d '{
    "jsonrpc": "2.0",
    "id": 0,
    "method": "initialize",
    "params": {
        "protocolVersion": "2024-11-05",
        "capabilities": {},
        "clientInfo": {"name": "bash-client", "version": "1.0"}
    }
}' > /dev/null

# 4. Send Initialized with API Key header
curl -s -X POST "${FULL_POST_URL}" \
    -H "Content-Type: application/json" \
    -H "X-API-Key: ${API_KEY}" \
    -d '{
    "jsonrpc": "2.0",
    "method": "notifications/initialized"
}' > /dev/null

# 5. Execute Command (list_tools or call_tool)
MODE="$1"

if [ "$MODE" == "check" ]; then
    # Call tools/list
    ID=1
    curl -s -X POST "${FULL_POST_URL}" \
        -H "Content-Type: application/json" \
        -H "X-API-Key: ${API_KEY}" \
        -d "{
        \"jsonrpc\": \"2.0\",
        \"id\": $ID,
        \"method\": \"tools/list\"
    }" > /dev/null
    
    # Wait for result in SSE stream
    # We look for "id": 1
    # This is tricky in bash grep. We wait a bit.
    sleep 2
    
    if grep -q "\"id\":\s*1" "$SSE_OUT" || grep -q "\"id\":1" "$SSE_OUT"; then
         # grep the line? SSE sends `event: message` then `data: JSON`
         # We need to extract the JSON line corresponding to result 1.
         # For simplicity, if we see result and no error, we assume success.
         if grep -q "search" "$SSE_OUT"; then
             echo "✅ Status: Operational"
             exit 0
         else
             echo "⚠️  Status: Connected but 'search' tool missing"
             exit 1
         fi
    else
         echo "❌ Status: No response from server"
         exit 1
    fi

elif [ "$MODE" == "search" ]; then
    QUERY="$2"
    ID=2
    # call_tool
    # Need to escape query for JSON?
    # Simple jq use to construct payload
    PAYLOAD=$(jq -n --arg q "$QUERY" \
    '{jsonrpc: "2.0", id: 2, method: "tools/call", params: {name: "search", arguments: {query: $q}}}')

    curl -s -X POST "${FULL_POST_URL}" \
        -H "Content-Type: application/json" \
        -H "X-API-Key: ${API_KEY}" \
        -d "$PAYLOAD" > /dev/null

    # Wait for result
    MAX_WAIT=120
    WAIT=0
    FOUND=0
    while [ $WAIT -lt $MAX_WAIT ]; do
        # look for response to id 2
        # Data line will contain "id": 2
        if grep -q "\"id\":\s*2" "$SSE_OUT" || grep -q "\"id\":2" "$SSE_OUT"; then
            FOUND=1
            break
        fi
        sleep 0.5
        WAIT=$((WAIT+1))
    done
    
    if [ $FOUND -eq 1 ]; then
        # Extract the JSON line
        # This is hacky: grep the line containing id:2
        # SSE data format: data: {...}
        RESULT_JSON=$(grep "\"id\":\s*2" "$SSE_OUT" | sed 's/^data: //')
        if [ -z "$RESULT_JSON" ]; then
             RESULT_JSON=$(grep "\"id\":2" "$SSE_OUT" | sed 's/^data: //')
        fi
        
        # Check for error
        IS_ERROR=$(echo "$RESULT_JSON" | jq '.error')
        if [ "$IS_ERROR" != "null" ]; then
            echo "❌ Error from MCP: $IS_ERROR"
            exit 1
        fi
        
        # Extract content text
        # Result structure: .result.content[].text
        echo "$RESULT_JSON" | jq -r '.result.content[] | select(.type=="text") | .text'
    else
        echo "❌ Timeout waiting for search results"
        exit 1
    fi
fi
