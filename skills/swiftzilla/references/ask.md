# Ask — Swift/iOS Knowledge Base Query

## What it is

`ask` sends a natural-language Swift/iOS question to the SwiftZilla MCP knowledge base and returns a curated answer.

It is for implementation guidance, patterns, best practices, and architecture tradeoffs.

## When to use

- "How should I implement X in SwiftUI?"
- "What is the best practice for actors/concurrency here?"
- "How do I test this iOS pattern?"

## Command

### `swiftzilla ask`

```bash
swiftzilla ask "how to use async/await in Swift"
```

| Argument | Required | Description |
|----------|----------|-------------|
| `query` | Yes | Natural-language Swift/iOS question |

## Requirements

Set `SWIFTZILLA_API_KEY` via environment variable or `.env` file.

Option A:

```bash
export SWIFTZILLA_API_KEY=your_key_here
```

Option B (`.env` in project root):

```dotenv
SWIFTZILLA_API_KEY=your_key_here
```

## Example questions

```bash
swiftzilla ask "best practices for Swift Concurrency actors"
swiftzilla ask "how to implement navigation in SwiftUI"
swiftzilla ask "MVVM vs MVC in iOS apps"
swiftzilla ask "how to mock network calls in XCTest"
```

## Ask vs DepGraph

| Need | Command |
|------|---------|
| Analyze file dependencies in your project | `depgraph query` |
| Estimate blast radius for line-level change | `depgraph impact` |
| Get Swift/iOS implementation guidance | `ask` |
