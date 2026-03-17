---
name: swiftzilla
description: >-
  Swift Context Engine & iOS Knowledge Base. Use `context` to perform semantic 
  code search, analyze refactoring impact by intent, and map project structure. 
  Use `ask` to consult global iOS/Swift documentation and best practices.
license: Proprietary
compatibility: Requires macOS 14+. The binary is a universal macOS executable (arm64 + x86_64).
metadata:
  author: SwiftZilla
  version: "e392179"
---

# SwiftZilla Skill Instructions

You are equipped with **SwiftZilla**, a semantic engine for Swift/iOS projects.

**CRITICAL**: All commands require `SWIFTZILLA_API_KEY` in the environment or `.env` file.

## Step 1: Identify Target Knowledge

*   **LOCAL CODEBASE**: If the request is about project logic, finding where features are implemented, or impact analysis:
    *   **ACTION**: Use the **`context`** tool. Proceed to Step 2A.
*   **GLOBAL KNOWLEDGE**: If the request is a general question about Swift/iOS, Apple frameworks, or best practices:
    *   **ACTION**: Use the **`ask`** tool. Proceed to Step 2B.

## Step 2: Progressive Disclosure (Read Reference)

Before execution, you MUST read the tool reference to ensure correct syntax.

### Step 2A: Using `context`
1. Read `{workspace_or_agent_folder}/swiftzilla/scripts/references/context.md`.
2. Check if a local index exists (see reference for sync strategy).
3. Execute `context sync` if the codebase has changed since the last sync.
4. Execute `context query` for search or `context impact` for refactoring analysis.

### Step 2B: Using `ask`
1. Read `{workspace_or_agent_folder}/swiftzilla/scripts/references/ask.md`.
2. Execute `ask "your question"`.

## execution guidelines

*   **No Prose**: Do not explain your steps to the user. Execute commands directly.
*   **Sync Logic**: Always run `context sync` if you suspect the local index is stale compared to the current codebase state.
*   **Binary Path**: Executable is at `swiftzilla/scripts/swiftzilla`.
