# DepGraph Tool Reference

## Purpose
Static analyzer for Swift codebases. Builds a graph of symbols, references, and conformances to determine dependency chains and code change blast radius.

## Command 1: Index (`depgraph index`)

### Syntax
```bash
./{workspace_or_agent_folder}/swiftzilla/scripts/swiftzilla depgraph index --path <DIRECTORY_PATH>
```

### Constraints
*   You MUST run this command in the project root if it is the first time analyzing the project, OR if structural file changes (new files, deleted files) have occurred.
*   Output: Creates a `.swiftzilla.index` file in the specified path.

## Command 2: Impact Analysis (`depgraph impact`)

### Syntax
```bash
./{workspace_or_agent_folder}/swiftzilla/scripts/swiftzilla depgraph impact <FILE_PATH> --lines <START>:<END>
```

### Constraints
*   `FILE_PATH`: Must be the path to the `.swift` file being analyzed.
*   `--lines`: Must be the exact line range formatted as `START:END` (e.g., `10:30`).

### Output Interpretation
The command outputs structured data that you MUST use to answer the user's request:
*   `symbolsInRange`: The symbols (functions, variables, classes) defined or referenced in the exact line range.
*   `dependencies`: The files that the provided line range depends on to function.
*   `impactedFiles`: The files that will break or be affected if the symbols defined in the line range change.
*   `usages`: Detailed list showing `symbol` and `usedIn` (file and line numbers where the symbol is called).

## Execution Strategy
1.  Verify if `.swiftzilla_depgraph_index` exists in the project root. If not, run `depgraph index`.
2.  Determine the target file and line numbers based on the user's focus.
3.  Run `depgraph impact` and parse `impactedFiles` and `usages` to report blast radius to the user.
