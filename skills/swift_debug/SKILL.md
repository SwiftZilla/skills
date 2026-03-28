---
name: swift_debug
description: >-
  Use this skill for semantic runtime debugging and state analysis. 
  It provides LLDB plugins to bridge code context with runtime state.
license: Proprietary
compatibility: Requires macOS 14+. Universal macOS executable (arm64 + x86_64).
metadata:
  author: SwiftZilla
  version: "8e919ce"
---

# Swift Debug: Semantic Runtime Debugging

Use this tool to bridge static code context with dynamic runtime state.

> **Note**: The tool path `<SWIFT_DEBUG_SKILL_PATH>` refers to the root directory of this skill.

## 🛠️ Tool Usage

Run `install` to setup LLDB plugin, then use `sz_` commands in LLDB.
- **Intent**: "Debug crash", "Inspect runtime state", "Semantic breakpoints".

### Tool Commands

1.  **`install`**: Sets up the LLDB Python plugin and generates a script in `~/.lldbinit`.
```bash
<SWIFT_DEBUG_SKILL_PATH>/scripts/swift_debug install
```

2.  **`explain`**: Explains the purpose and context of a specific file and line.
3.  **`location`**: Finds the file and line for a semantic query.
4.  **`state`**: Processes raw runtime data (JSON) into a semantic report.

### LLDB Extension Commands (After Install)

- **`sz_break "<QUERY>"`**: Sets a breakpoint by searching for code semantically.
- **`sz_explain`**: Explains the current execution frame.
- **`sz_inspect`**: Captures stacktrace and variable values for semantic analysis.

## 🔄 Procedural Workflow
1. **Install**: Run `install` once.
2. **Debug**: Use `sz_inspect` or `sz_explain` during an LLDB session.
