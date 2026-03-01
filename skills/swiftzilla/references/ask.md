# Ask Tool Reference

## Purpose
Queries the SwiftZilla MCP knowledge base for natural-language Swift/iOS best practices, patterns, and architecture tradeoff guidance.

## Execution Syntax

Execute the following command, replacing `"YOUR_QUERY"` with the specific Swift/iOS question:

```bash
./{workspace_or_agent_folder}/swiftzilla/scripts/swiftzilla ask "YOUR_QUERY"
```

## Constraints & Requirements

*   **API Key**: This command REQUIRES the `SWIFTZILLA_API_KEY` environment variable.
    *   If the command fails with an authentication or missing key error, check if `.env` exists in the project root containing `SWIFTZILLA_API_KEY=...` or ensure it is exported in the shell environment.
    *   If the key is completely missing, you MUST inform the user to provide it. Do NOT hallucinate an answer.
*   **Query Format**: The query must be wrapped in double quotes.

## Output Handling

*   The output will contain the curated answer from the knowledge base.
*   Analyze the output and present the technical guidance directly to the user. Do not summarize unless the user specifically asked for a summary.

## Restrictions

*   Do NOT use `ask` for analyzing file dependencies or blast radius. Use `depgraph` instead.
