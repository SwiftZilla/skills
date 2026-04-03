---
name: swift_ask
description: >-
  Use this skill for expert Swift/iOS architectural guidance and best practices.
  It provides a senior mentor layer to validate patterns before implementation.
  Use when asking "how should I architect X", "what are tradeoffs of Y",
  "SwiftUI best practices", "Swift concurrency patterns", or any general
  Swift/iOS design question — even if they don't explicitly mention "Swift"
  or "iOS" but describe mobile app architecture concerns.
license: Proprietary
compatibility: Requires macOS 14+. Universal macOS executable (arm64 + x86_64).
metadata:
  author: SwiftZilla
  version: "9284a89"
---

# Swift Ask: Senior Swift Mentor

Run this tool BEFORE implementing complex patterns to validate your architectural approach against senior-level standards.

## Tool Usage

Execute the `swift_ask` wrapper script from the skill's `scripts/` folder:

```bash
scripts/swift_ask "<NATURAL_LANGUAGE_QUESTION>"
```

### Constraints

- **API Key**: Mandatory `SWIFTZILLA_API_KEY` environment variable.
- **Scope**: Use ONLY for general Swift/iOS questions. For project-specific questions (local codebase analysis, file locations, dependency mapping), use `swift_context` instead.

## Gotchas

- The tool returns general Swift/iOS guidance — it has NO knowledge of your local codebase. Always cross-reference suggestions against your project's actual architecture.
- If the question is about where something lives in your codebase or what depends on what, use `swift_context` instead — this skill cannot answer local code questions.
- API key errors are fatal — check `SWIFTZILLA_API_KEY` is set before running.

## Workflow

1. Formulate your architectural question in natural language
2. Run `scripts/swift_ask "<question>"`
3. Review the guidance returned by the tool
4. Use the guidance to inform your implementation approach
