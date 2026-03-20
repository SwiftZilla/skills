# Review Tool Reference

Analyzes git diff and predicts the semantic risk and impact of current changes.

## Tool Commands

### 1. `review`
Scans the current uncommitted changes (or against a target branch) and maps them to the dependency graph.

### 2. `review --target <BRANCH>`
Compares current state against a specific branch (e.g., `main`) to find the full scope of a PR.

## Agent Workflow

1.  **Safety Check**: Always run `./swiftzilla/scripts/swiftzilla review` before committing or finalizing a PR.
2.  **Risk Assessment**: Look for "High Impact" warnings (high Fan-In). If a change affects core components, alert the user.
3.  **Verification**: For each file mentioned in the "Impacted Files" list, recommend running its specific tests.
