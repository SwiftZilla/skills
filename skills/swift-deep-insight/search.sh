#!/bin/bash

# Configuration
# Note: SWIFTZILLA_API_KEY must be set in env

# 1. Validate API Key Presence
if [ -z "$SWIFTZILLA_API_KEY" ]; then
    echo "⚠️  Teacher Mode: API Key Missing"
    echo "To use this skill, you must set the 'SWIFTZILLA_API_KEY' environment variable."
    exit 1
fi

# 2. Validate Query
QUERY="$1"
if [ -z "$QUERY" ]; then
    echo "⚠️  Teacher Mode: Query Missing"
    echo "Usage: ./search.sh \"your search query\""
    exit 1
fi

# 3. Execute Search via Bash MCP Client
SCRIPT_DIR="$(dirname "$0")"
# Ensure mcp.sh is executable
chmod +x "$SCRIPT_DIR/mcp.sh" 2>/dev/null

"$SCRIPT_DIR/mcp.sh" search "$QUERY"
