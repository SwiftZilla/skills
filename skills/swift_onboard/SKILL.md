---
name: swift_onboard
description: >-
  Use this skill for architecture documentation and generating high-level
  system overviews. It generates an ARCHITECTURE.md for your project.
  Use when onboarding to a new codebase, documenting project structure,
  creating system overviews, or understanding how components connect —
  even if they don't mention "architecture" but describe understanding
  or documenting a project's structure.
license: Proprietary
compatibility: Requires macOS 14+. Universal macOS executable (arm64 + x86_64).
metadata:
  author: SwiftZilla
  version: "082d423"
---

# Swift Onboard: Architecture Documentation

Generate or update your project's `ARCHITECTURE.md` with a high-level system overview.

## Tool Usage

```bash
scripts/swift_onboard
```

## Gotchas

- The tool scans the current working directory — make sure you're in the project root before running.
- If the project already has an `ARCHITECTURE.md`, the tool will update it rather than overwrite. Review the diff after generation.
- For large projects, the initial scan may take time. The output quality depends on the codebase's structural clarity — heavily nested or unconventional layouts may need manual supplementation.

## Workflow

1. **Orient**: Navigate to the project root and run `scripts/swift_onboard`
2. **Review**: Read the generated `ARCHITECTURE.md` to understand core components and entry points
3. **Supplement**: Add any domain-specific context the tool couldn't infer automatically
4. **Maintain**: Re-run after significant structural changes to keep documentation current
