# DepGraph — Swift Dependency and Impact Analyzer

## What it is

`depgraph` is a static analyzer for Swift codebases. It parses `.swift` files through the Swift AST and builds a graph of:

- symbols defined per file
- symbols referenced per file
- protocol/inheritance conformances

Use it to understand dependency chains and the blast radius of a code change.

## Core use cases

- "Who calls this function? Where is it used?"
- "If I change these lines, what files break?"
- "What does this code depend on before I refactor it?"

## Commands

### `swiftzilla depgraph index`

Build or refresh the project dependency index.

```bash
swiftzilla depgraph index --path /path/to/project
```

| Argument | Required | Default | Description |
|----------|----------|---------|-------------|
| `--path`, `-p` | No | Current directory | Root directory to scan |

Output: `.swiftzilla_depgraph_index` in project root.

### `swiftzilla depgraph impact`

Analyze dependency + impact for a specific line range.

```bash
swiftzilla depgraph impact Services/UserService.swift --lines 10:30
```

| Argument | Required | Default | Description |
|----------|----------|---------|-------------|
| `file` | Yes | — | File path (exact, partial, or filename) |
| `--lines`, `-l` | Yes | — | Line range as `start:end` |

Output includes:

- `symbolsInRange` — symbols found in the line range
  - `defined` — classes, structs, enums, protocols, extensions, **functions**, **variables**, **typealiases**, **inits**, **enum cases**
  - `referenced` — all type/symbol references used in the range
- `dependencies` (files this range depends on)
- `impactedFiles` (files affected by symbols defined in range)
- `usages` — per-symbol caller detail:
  - `symbol` — the defined symbol name
  - `usedIn` — list of `{ file, lines }` showing which files reference this symbol and at which lines

## Typical workflow

```bash
# 1. Build index once (re-run after structural file changes)
swiftzilla depgraph index --path .

# 2. Analyze blast radius — who calls this, what depends on it
swiftzilla depgraph impact Services/UserService.swift --lines 10:30
```
