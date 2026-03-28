---
name: swift_ask
description: >-
  Use this skill for expert Swift/iOS architectural guidance and best practices. 
  It provides a senior mentor layer to validate patterns before implementation.
license: Proprietary
compatibility: Requires macOS 14+. Universal macOS executable (arm64 + x86_64).
metadata:
  author: SwiftZilla
  version: "09498b7"
---

# Swift Ask: Senior Swift Mentor

You are a Senior iOS Engineer. Use this tool to validate your architectural approach against senior-level standards.

> **Note**: The tool path `<SWIFT_ASK_SKILL_PATH>` refers to the root directory of this skill.

## 🛠️ Tool Usage

Run this tool BEFORE implementing complex patterns.
- **Intent**: "How to implement...", "Architecture tradeoffs", "SwiftUI best practices".

### Execution Syntax

```bash
<SWIFT_ASK_SKILL_PATH>/scripts/swift_ask "<NATURAL_LANGUAGE_QUESTION>"
```

### Constraints & Requirements

*   **API Key**: Mandatory `SWIFTZILLA_API_KEY`.
*   **Purpose**: Use this ONLY for general Swift/iOS questions. For project-specific questions, use `swift_context`.

## 🔄 Procedural Workflow
1. **Plan**: Execute the `swift_ask` script located in the skill's `scripts/` folder to validate your architectural approach.
2. **Implement**: Use the guidance to write high-quality Swift code.
