# Context Tool Reference

Semantic engine for local Swift projects. Uses Hybrid Search (Vector + BM25) and AST Skeletons.

## Command 1: `context sync`
Synchronizes the local codebase with the encrypted cache. 

### Syntax
```bash
./swiftzilla/scripts/swiftzilla context sync --path <PROJECT_ROOT>
```

### LLM Strategy
*   **WHEN**: Run this if `~/.swiftzilla/cache` does not contain an index for the project OR if files have been modified/added since the last sync.
*   **PURPOSE**: Rebuilds the "brain" of the project (extracts signatures, generates embeddings, encrypts).

## Command 2: `context query`
Semantic search for code components.

### Syntax
```bash
./swiftzilla/scripts/swiftzilla context query "<NATURAL_LANGUAGE_QUERY>"
```

### LLM Strategy
*   **USE FOR**: "Where is X implemented?", "List all ViewModels", "How does the networking work?".
*   **OUTPUT**: Returns ranked code skeletons with file paths and line numbers.

## Command 3: `context impact`
Refactoring impact analysis using intent.

### Syntax
```bash
./swiftzilla/scripts/swiftzilla context impact "<INTENTION_OR_COMPONENT_NAME>"
```

### LLM Strategy
*   **USE FOR**: "What happens if I change the LoginService?", "Find blast radius of modifying the user session logic".
*   **OUTPUT**: Identifies the target component semantically and generates a Mermaid dependency graph of all impacted files.

## Constraints
*   **Encryption**: The index is stored as an encrypted `.bin` file in `~/.swiftzilla/cache`. Never attempt to read this file directly.
*   **Project Context**: The CLI automatically detects the project based on the current directory. Always `cd` into the project root before querying.
