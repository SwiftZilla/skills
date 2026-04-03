---
name: swift_review
description: >-
  Use this skill for PR safety and risk analysis. It analyzes the risk
  and blast radius of a PR using git diff. Use before committing changes,
  reviewing pull requests, or assessing the impact of code modifications —
  even if they don't mention "review" but describe checking change safety
  or understanding what a diff affects.
license: Proprietary
compatibility: Requires macOS 14+. Universal macOS executable (arm64 + x86_64).
metadata:
  author: SwiftZilla
  version: "082d423"
---

# Swift Review: PR Safety & Risk Analysis

Analyze the semantic impact of your changes and catch potential regressions before they land.

## Commands

```bash
# Review diff against current HEAD
scripts/swift_review

# Review diff against a specific target branch
scripts/swift_review --target <BRANCH>
```

## Workflow

1. **Analyze**: Run `scripts/swift_review` to see the semantic impact of your changes
2. **Assess risk**: Look for "High Impact" warnings (high Fan-In files) — these are the most dangerous changes to get wrong
3. **Verify**: For each file mentioned in the "Impacted Files" list, run its specific tests to confirm nothing broke
4. **Proceed**: Only commit when high-risk areas are covered by tests

## Gotchas

- Always run this BEFORE committing — not after. The tool analyzes uncommitted changes by default.
- "High Impact" means the file has many dependents (high Fan-In). Changes to these files have a larger blast radius and need more careful testing.
- If no tests exist for an impacted file, flag it for manual review — the tool cannot verify correctness without tests.
- When using `--target`, make sure the target branch is up to date locally — stale branches produce misleading diffs.
