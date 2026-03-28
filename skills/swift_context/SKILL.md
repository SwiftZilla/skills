---
name: swift_context
description: >-
  Use this skill for semantic codebase analysis and mapping local code 
  dependencies. It provides a semantic engine to query local code context.
license: Proprietary
compatibility: Requires macOS 14+. Universal macOS executable (arm64 + x86_64).
metadata:
  author: SwiftZilla
  version: "09498b7"
---

# Swift Context: Local Semantic Intelligence

Use this skill to map your project's "local reality" through semantic indexing.

> **Note**: The tool path `<SWIFT_CONTEXT_SKILL_PATH>` refers to the root directory of this skill.

## 🛠️ Tool Usage

Run `sync` to index, then `query` to locate logic or `impact` to see dependencies.
- **Intent**: "Where is X?", "What breaks if I change Y?", "Find all usages of Z".

### Commands

#### 1. `sync`
Rebuilds the encrypted semantic index.
```bash
<SWIFT_CONTEXT_SKILL_PATH>/scripts/swift_context sync --path <PROJECT_ROOT>
```

#### 2. `query`
Semantic search across the codebase.
```bash
<SWIFT_CONTEXT_SKILL_PATH>/scripts/swift_context query "<NATURAL_LANGUAGE_QUERY>"
```

#### 3. `impact`
Analyzes the blast radius of a planned change.
```bash
<SWIFT_CONTEXT_SKILL_PATH>/scripts/swift_context impact "<INTENTION_OR_COMPONENT_NAME>"
```

### LLM Strategy (When to Sync?)
1.  **Missing Cache**: Run this if no corresponding `.bin` file exists in `~/.swiftzilla/cache`.
2.  **Stale Index**: If the project files are newer than the cache file, run `sync`.
3.  **Ambiguity**: If `query` returns unexpected results after a refactor, run `sync`.

## 🔄 Procedural Workflow
1. **Sync**: Run `sync` after major file additions or refactors.
2. **Query**: Use `query` to find relevant implementation details.
3. **Impact**: Use `impact` to see the blast radius of a change.
