# Onboard Tool Reference

Generates high-level architectural documentation and maps the core project structure.

## Tool Commands

### 1. `onboard`
Scans the entire project and generates an `ARCHITECTURE.md` file with system overviews, entry points, and dependency diagrams.

## Agent Workflow

1.  **Project Initiation**: Run `./swiftzilla/scripts/swiftzilla onboard` when you first start working on a project.
2.  **Structural Mapping**: Use the generated `ARCHITECTURE.md` to identify:
    - **Core Components**: Highest impact/Fan-In files.
    - **Entry Points**: Where the execution starts.
    - **Module Flow**: How the main modules are interconnected.
3.  **Documentation Sync**: If the project structure changes significantly, run `onboard` again to update the documentation.
