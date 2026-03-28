---
name: swift_review
description: >-
  Use this skill for PR safety and risk analysis. It analyzes the risk 
  and blast radius of a PR using git diff.
license: Proprietary
compatibility: Requires macOS 14+. Universal macOS executable (arm64 + x86_64).
metadata:
  author: SwiftZilla
  version: "8e919ce"
---

# Swift Review: PR Safety & Risk Analysis

Use this tool to analyze the impact of your PR and catch potential regressions.

> **Note**: The tool path `<SWIFT_REVIEW_SKILL_PATH>` refers to the root directory of this skill.

## 🛠️ Tool Usage

Run `review` before proposing or finalizing ANY change to catch regressions.
- **Intent**: "Review my diff", "Analyze PR impact", "Check for high-risk changes".

### Execution Syntax

#### 1. Diff against current HEAD
```bash
<SWIFT_REVIEW_SKILL_PATH>/scripts/swift_review
```

#### 2. Diff against a target branch
```bash
<SWIFT_REVIEW_SKILL_PATH>/scripts/swift_review --target <BRANCH>
```

### Agent Workflow
1.  **Safety Check**: Always run this before committing or finalizing a PR.
2.  **Risk Assessment**: Look for "High Impact" warnings (high Fan-In).
3.  **Verification**: For each file mentioned in the "Impacted Files" list, recommend running its specific tests.

## 🔄 Procedural Workflow
1. **Analyze**: Run `swift_review` to see the semantic impact of your changes.
2. **Verify**: Ensure your changes don't impact unrelated core components.
