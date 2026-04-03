---
name: swift_deep_insight
description: >-
  Identify unused code in Swift projects using the Swift compiler's index store.
  Detects unused classes, structs, functions, properties, protocols, and more.
  Use when cleaning up dead code, auditing codebase health, preparing for
  refactoring, or reviewing PR scope — even if they don't mention "index store"
  or "dead code" but describe removing unused or unreachable code.
license: Proprietary
compatibility: Requires macOS 14+. Universal macOS executable (arm64 + x86_64).
metadata:
  author: SwiftZilla
  version: "1.0.0"
---

# Swift Deep Insight: Unused Code Detection

Detect unused (dead) code in Swift projects using the Swift compiler's index store.

## Prerequisites

### Xcode Projects
Build the project in Xcode first — the index store is created automatically at `~/Library/Developer/Xcode/DerivedData/<Project>/Index/DataStore`.

### SPM Projects
Build with `xcodebuild -scheme <scheme> build` or `swift build`.

## Commands

Run from the project root or specify a path:

```bash
# Scan current directory
swift run swift-deep-insight --project-path .

# Verbose output
swift run swift-deep-insight --project-path . --verbose

# Xcode-clickable output (file:line:column:)
swift run swift-deep-insight --project-path . --xcode-format

# Include public declarations (normally excluded)
swift run swift-deep-insight --project-path . --include-public
```

### Options

| Option | Description |
|--------|-------------|
| `--project-path` | Path to Swift project (default: current directory) |
| `--verbose` | Enable detailed logging |
| `--xcode-format` | Output in Xcode-compatible format (file:line:column:) |
| `--include-public` | Include public declarations in unused analysis |
| `--exclude-tests` | Exclude test targets from analysis |
| `--build` | Build the project before scanning (default: false) |

## Gotchas

- **No index store = limited results**: Without the index store, analysis falls back to source-only parsing and misses cross-file references. Always build first.
- **Runtime reflection is invisible**: Code used via `responds(to:)`, `perform()`, or other runtime mechanisms will appear unused even though it's called.
- **External packages are not analyzed**: Only your project's code is scanned, not dependencies.
- **Public declarations are excluded by default**: Public/API symbols are assumed to be used by consumers. Use `--include-public` to override.
- **Entry points are auto-detected**: `main`, `@main`, `@NSApplicationMain`, and `AppDelegate` are treated as roots — everything reachable from them is "used".

## Workflow

1. **Build**: Ensure the project is built so the index store is fresh
2. **Scan**: Run the analyzer with appropriate flags
3. **Review**: Examine unused declarations — verify each is truly dead code before removing
4. **Validate**: After removal, rebuild and run tests to confirm nothing was incorrectly classified
