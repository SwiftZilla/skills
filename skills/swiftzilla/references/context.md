# Context Tool Reference

Use this tool for local Swift project understanding and impact analysis.

## Command 1: `context sync`
Rebuilds the encrypted semantic index.

```bash
./swiftzilla context sync --path <PROJECT_ROOT>
```

### When to Sync? (LLM Strategy)
1.  **Missing Cache**: Run this if no corresponding `.bin` file exists in `~/.swiftzilla/cache`.
2.  **Stale Index**: Use `ls -l` to compare the timestamp of the project directory with the cache file. If the project is newer, run `sync`.
3.  **Ambiguity**: If `query` returns unexpected results after a refactor, run `sync`.

## Command 2: `context query`
Semantic search across the codebase.

```bash
./swiftzilla context query "<NATURAL_LANGUAGE_QUERY>"
```
- Returns ranked code "skeletons" (signatures + properties).
- Use for "Where is X implemented?", "List all SwiftUI Views".

## Command 3: `context impact`
Analyzes the blast radius of a planned change.

```bash
./swiftzilla context impact "<INTENTION_OR_COMPONENT_NAME>"
```
- Locates the target semantically.
- Generates a Mermaid dependency graph.
- Lists files that will break if the target changes.

## Diagnostics
- **Error: ❌ Index not found**: Trigger `context sync` immediately.
- **Error: ❌ Authentication failed**: The `SWIFTZILLA_API_KEY` is invalid or expired.
- **Empty results**: The query is too specific or not semantically relevant. Try a broader intent.
