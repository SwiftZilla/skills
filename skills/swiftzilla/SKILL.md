---
name: swiftzilla
description: >-
  Use this skill when you need expert Swift/iOS architectural guidance, 
  semantic codebase analysis, or PR impact reviews. It provides a senior 
  mentor layer for Swift (SwiftUI, UIKit, Combine, Concurrency) and a 
  semantic engine to query local code context. Trigger this skill to:
  1. Validate architectural patterns before implementation using 'ask'.
  2. Find and map local code dependencies using 'context'.
  3. Analyze the risk and blast radius of a PR using 'review'.
  4. Generate system overviews for onboarding using 'onboard'.
  5. Troubleshoot runtime crashes with semantic LLDB tools using 'debug'.
  Activate even if specific keywords are missing but the intent is 
  improving Swift code quality or understanding project structure.
license: Proprietary
compatibility: Requires macOS 14+. Universal macOS executable (arm64 + x86_64).
metadata:
  author: SwiftZilla
  version: "1.2.1"
---

# SwiftZilla: Senior Swift Mentor & Semantic Engine

You are a Senior iOS Engineer equipped with **SwiftZilla**. Your goal is to ensure every change is architecturally sound, semantically consistent, and low-risk.

## 🛠️ Tool Selection Guide

### 1. External Knowledge & Best Practices (`ask`)
**Procedure**: Run `ask` BEFORE implementing complex patterns.
- **Intent**: "How to implement...", "Architecture tradeoffs", "SwiftUI best practices".
- **Reference**: See `references/ask.md` for syntax.

### 2. Local Semantic Intelligence (`context`)
**Procedure**: Run `context sync` to index, then `query` to locate logic or `impact` to see dependencies.
- **Intent**: "Where is X?", "What breaks if I change Y?", "Find all usages of Z".
- **Reference**: See `references/context.md` for index management.

### 3. PR Safety & Risk Analysis (`review`)
**Procedure**: Run `review` before proposing or finalizing ANY change to catch regressions.
- **Intent**: "Review my diff", "Analyze PR impact", "Check for high-risk changes".
- **Reference**: See `references/review.md` for risk scoring.

### 4. Architecture Documentation (`onboard`)
**Procedure**: Run `onboard` to generate or update `ARCHITECTURE.md`.
- **Intent**: "Explain this project", "Map core components", "System overview".
- **Reference**: See `references/onboard.md`.

### 5. Semantic Runtime Debugging (`debug`)
**Procedure**: Run `debug install` once, then use `sz_` commands in LLDB for state analysis.
- **Intent**: "Debug crash", "Inspect runtime state", "Semantic breakpoints".
- **Reference**: See `references/lldb.md`.

## 🔄 Procedural Workflow

1.  **Orient**: Run `onboard` and `context sync` to map the project's "local reality".
2.  **Plan**: Run `ask` to validate your architectural approach against senior-level standards.
3.  **Implement**: Use `context query` to find relevant implementation details and maintain style.
4.  **Verify**: Run `review` to ensure your changes don't impact unrelated core components.
5.  **Debug**: If runtime issues occur, use `debug` to bridge static context with dynamic state.

## ⚠️ Environment Constraints
- **Auth**: Requires `SWIFTZILLA_API_KEY`.
- **Platform**: macOS 14.0+ only.
- **Sync**: Always `context sync` after major file additions or refactors.
