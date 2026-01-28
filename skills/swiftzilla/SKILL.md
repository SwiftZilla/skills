---
name: swiftzilla
description: >-
  Swift/iOS static analysis CLI. Use `depgraph` to find who calls a function,
  what breaks if you change a file, track call sites and blast radius before
  refactoring, and map symbol dependencies across files. Use `ask` to consult
  Swift/iOS/tvOS/watchOS/macOS documentation and best practices.
license: Proprietary
compatibility: Requires macOS 13+. The binary is a universal macOS executable (arm64 + x86_64).
metadata:
  author: SwiftZilla
  version: "6d0bb5e"
---

# SwiftZilla CLI

Swift/iOS static analysis and knowledge base:

1. **`depgraph`** — Find who calls a function, what breaks if you refactor, track call sites and blast radius
2. **`ask`** — Consult Swift/iOS/tvOS/watchOS/macOS documentation and best practices

## Installation

The `swiftzilla` binary is in `{workspace_or_agent_folder}/swiftzilla/scripts/`. Make it executable:

```bash
chmod +x ./{workspace_or_agent_folder}/swiftzilla/scripts/swiftzilla
```

## When to use SwiftZilla

| Situation | Command |
|-----------|---------|
| First run in a new project | `depgraph index --path .` |
| Who calls this function/method? | `depgraph impact <file> --lines start:end` |
| What breaks if I change these lines? | `depgraph impact <file> --lines start:end` |
| What does this code depend on? | `depgraph impact <file> --lines start:end` |
| Ask Swift/iOS best-practice questions | `ask "your question"` |

## Quick Start

```bash
# 1. Build dependency index (re-run after structural file changes)
swiftzilla depgraph index --path .

# 2. Analyze blast radius — who calls this, what depends on it
swiftzilla depgraph impact UserService.swift --lines 10:30

# 3. Ask the Swift/iOS knowledge base
swiftzilla ask "how to use async/await with actors"
```

## Detailed References

- [DepGraph Reference](references/depgraph.md) — dependency indexing and impact analysis
- [Ask Reference](references/ask.md) — curated Swift/iOS knowledge lookup

## Requirements

- macOS 13 (Ventura) or later
- A Swift project with `.swift` source files for `depgraph`
- `SWIFTZILLA_API_KEY` for `ask` (see [Ask Reference](references/ask.md))
