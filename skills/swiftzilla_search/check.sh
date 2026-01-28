#!/bin/bash

# Configuration
# Note: SWIFTZILLA_API_KEY must be set in env

echo "🔍 Checking SwiftZilla Deep Insight System..."
echo "------------------------------------------------"

# 1. Validate Env
if [ -z "$SWIFTZILLA_API_KEY" ]; then
    echo "❌ Status: Config Missing"
    echo "Reason: 'SWIFTZILLA_API_KEY' environment variable is not set."
    echo "Action: Ask the user for their API Key at https://swiftzilla.dev/dashboard.html"
    exit 1
fi

# 2. Execute Check via Bash MCP Client
SCRIPT_DIR="$(dirname "$0")"
chmod +x "$SCRIPT_DIR/mcp.sh" 2>/dev/null

"$SCRIPT_DIR/mcp.sh" check
