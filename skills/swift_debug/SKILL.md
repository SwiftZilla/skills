---
name: swift_debug
description: >-
  Use this skill for semantic runtime debugging and state analysis.
  It provides LLDB plugins to bridge code context with runtime state.
  Use when debugging crashes, inspecting variable state at runtime,
  setting semantic breakpoints, or analyzing why code behaves differently
  than expected — even if they don't mention "LLDB" or "debugger".
license: Proprietary
compatibility: Requires macOS 14+. Universal macOS executable (arm64 + x86_64).
metadata:
  author: SwiftZilla
  version: "f5999e1"
---

# Swift Debug: Semantic Runtime Debugging

Bridge static code context with dynamic runtime state using LLDB extensions.

## Setup

Install the LLDB plugin once per environment:

```bash
scripts/swift_debug install
```

This sets up the Python plugin and adds the loader script to `~/.lldbinit`.

## LLDB Commands (After Install)

Once installed, these commands are available in any LLDB session:

- **`sz_break "<QUERY>"`**: Set a breakpoint by semantic search (e.g., `sz_break "user authentication logic"`)
- **`sz_explain`**: Explain the current execution frame — what this code does and why
- **`sz_inspect`**: Capture stacktrace and variable values for semantic analysis

## Gotchas

- The plugin must be installed BEFORE debugging — `sz_*` commands will not exist in LLDB without running `install` first.
- `sz_break` uses semantic matching, not line numbers. If the query is too broad, it may set multiple breakpoints — review them with `breakpoint list`.
- Runtime state captured by `sz_inspect` is a snapshot — variables may change between inspection and your next step.
- If `~/.lldbinit` already exists and is managed by another tool, the install script appends to it. Check for conflicts if LLDB behaves unexpectedly.

## Workflow

1. **Install**: Run `scripts/swift_debug install` (one-time setup)
2. **Locate**: Use `sz_break "<query>"` to set breakpoints semantically
3. **Inspect**: When hit, use `sz_inspect` to capture runtime state
4. **Understand**: Use `sz_explain` to understand the execution context
