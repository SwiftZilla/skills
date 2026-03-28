---
name: swift_onboard
description: >-
  Use this skill for architecture documentation and generating high-level 
  system overviews. It generates an ARCHITECTURE.md for your project.
license: Proprietary
compatibility: Requires macOS 14+. Universal macOS executable (arm64 + x86_64).
metadata:
  author: SwiftZilla
  version: "8e919ce"
---

# Swift Onboard: Architecture Documentation

Use this skill to generate or update your project's `ARCHITECTURE.md`.

> **Note**: The tool path `<SWIFT_ONBOARD_SKILL_PATH>` refers to the root directory of this skill.

## 🛠️ Tool Usage

Run this tool to generate a high-level overview of your project structure.
- **Intent**: "Explain this project", "Map core components", "System overview".

### Execution Syntax
```bash
<SWIFT_ONBOARD_SKILL_PATH>/scripts/swift_onboard
```

### Agent Workflow
1.  **Project Initiation**: Run this when you first start working on a project.
2.  **Structural Mapping**: Use the generated `ARCHITECTURE.md` to identify core components and entry points.
3.  **Documentation Sync**: If the project structure changes significantly, run it again.

## 🔄 Procedural Workflow
1. **Orient**: Run `swift_onboard` to map the project's core components.
2. **Document**: Keep your ARCHITECTURE.md up to date.
