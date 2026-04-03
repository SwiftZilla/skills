---
name: swift_context
description: >-
  Use this skill for semantic codebase analysis and mapping local code
  dependencies. It provides a semantic engine to query local code context.
  Use when asking "where is X implemented", "what depends on Y", "find all
  usages of Z", "what breaks if I change this", or any question about your
  local project's code structure, dependencies, or impact analysis.
license: Proprietary
compatibility: Requires macOS 14+. Universal macOS executable (arm64 + x86_64).
metadata:
  author: SwiftZilla
  version: "f5999e1"
---

# Swift Context: Local Semantic Intelligence

Use this skill to map your project's code structure through semantic indexing.

## Commands

### sync

Rebuilds the encrypted semantic index. Run when files have changed significantly.

```bash
scripts/swift_context sync --path <PROJECT_ROOT>
```

### query

Semantic search across the indexed codebase.

```bash
scripts/swift_context query "<NATURAL_LANGUAGE_QUERY>"
```

### impact

Analyzes the blast radius of a planned change.

```bash
scripts/swift_context impact "<INTENTION_OR_COMPONENT_NAME>"
```

## When to Sync

Run `sync` in these cases:

1. **Missing cache**: No corresponding `.bin` file exists in `~/.swiftzilla/cache`
2. **Stale index**: Project files are newer than the cached index
3. **Unexpected results**: After a refactor, `query` returns irrelevant results

## Gotchas

- The index is encrypted and cached in `~/.swiftzilla/cache` — if you switch projects, the old cache may still be used. Always `sync` with the correct `--path` after switching projects.
- `query` returns semantic matches, not exact text matches. If you need exact string search, use standard grep/find tools instead.
- After major refactors, always re-sync before running `impact` — stale indexes produce incorrect dependency maps.

## Workflow

1. **Sync**: Run `sync` if the index is missing or stale
2. **Query**: Use `query` to find relevant code locations and understand implementation details
3. **Impact**: Use `impact` before making changes to understand what else will be affected
