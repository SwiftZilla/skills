# LLDB Semantic Debugging

The `debug` tool provides semantic intelligence for runtime troubleshooting. It bridges the gap between LLDB (dynamic state) and SwiftZilla's context engine (static knowledge).

## Tool Commands

### 1. `debug install`
Sets up the LLDB Python plugin and generates a script to be loaded in `~/.lldbinit`.

### 2. `debug explain`
Explains the purpose and context of a specific file and line.

### 3. `debug location`
Finds the file and line for a semantic query (used by `sz_break`).

### 4. `debug state`
Processes raw runtime data (JSON) into a human-readable/AI-interpretable semantic report.

## LLDB Extension Commands

Once installed, these commands are available directly in the LLDB console:

- **`sz_break "<NATURAL_LANGUAGE_QUERY>"`**: Sets a breakpoint by searching for code semantically.
- **`sz_explain`**: Explains the current execution frame and its purpose.
- **`sz_inspect`**: Captures stacktrace and variable values, then passes them to SwiftZilla for semantic analysis.

## Agent Workflow

1.  **Initial Setup**: If the user asks to debug or use `sz_` commands, first run `./swiftzilla/scripts/swiftzilla debug install`.
2.  **Semantic Breakpoints**: Use `sz_break` to stop the execution at a conceptual location (e.g., "where token is validated").
3.  **State Analysis**: Once stopped, use `sz_inspect` to get a structured report of the current state, variables, and why the current code matters.
4.  **Impact Mapping**: Combine `sz_inspect` with `context impact` to see how the current state might ripple through the system.
