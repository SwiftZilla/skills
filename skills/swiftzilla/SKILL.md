---
name: swiftzilla
description: >-
  Use this skill when you need to understand, search, or analyze a Swift/iOS 
  codebase semantically. Trigger this skill to find where features are 
  implemented, perform refactoring impact analysis, or ask general questions 
  about Swift/iOS best practices. Use it even if the user doesn't mention 
  indexing or specific files.
license: Proprietary
compatibility: Requires macOS 14+. The binary is a universal macOS executable (arm64 + x86_64).
metadata:
  author: SwiftZilla
  version: "92a9f9c"
---

# SwiftZilla: Semantic Code Engine

You are equipped with **SwiftZilla**, a tool for deep code understanding. 

## Triggers
- "Where is the login logic?" -> Use `context query`.
- "What happens if I change the API service?" -> Use `context impact`.
- "How do I implement a Coordinator pattern?" -> Use `ask`.

## Workflow

### 1. Identify Intent
- **Local Project**: Use the **`context`** tool. Proceed to Step 2A.
- **General iOS Knowledge**: Use the **`ask`** tool. Proceed to Step 2B.

### 2. Progressive Disclosure
Read the specific reference to get the exact syntax and strategy.

#### 2A: Local Analysis (`context`)
1. Read `references/context.md` to understand `sync`, `query`, and `impact`.
2. **Validation**: Run `context sync` if you see no index in `~/.swiftzilla/cache` or if code has changed.
3. Perform the analysis and return structured results.

#### 2B: Global Knowledge (`ask`)
1. Read `references/ask.md`.
2. Execute the query and provide the expert answer.

## Gotchas & Environment
- **Auth**: `SWIFTZILLA_API_KEY` must be set in environment or `.env`.
- **Binary**: Always ensure `chmod +x swiftzilla/scripts/swiftzilla` before execution.
- **Platform**: Fails on macOS < 14.0.

## Execution Checklist
- [ ] Check `SWIFTZILLA_API_KEY` availability.
- [ ] Ensure binary is executable.
- [ ] Decide if `context sync` is needed (First run or code changes).
- [ ] Run the target command.
