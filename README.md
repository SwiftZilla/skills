# AI Agent Skills

This repository contains custom skills for AI agents, providing specialized capabilities and integrations for Swift and the Apple ecosystem.

## Available Skills

### SwiftZilla
Search Swift technical context using SwiftZilla Deep Insight™ and analyze project dependencies with `depgraph`.
**Location:** [skills/swiftzilla/](./skills/swiftzilla/)

### Swift Best Practices & Ecosystem
We also offer curated knowledge base skills for the Swift ecosystem:
- **Swift Combine:** [skills/swift_combine/](./skills/swift_combine/)
- **Swift Concurrency:** [skills/swift_concurrency/](./skills/swift_concurrency/)
- **Swift Package Manager:** [skills/swift_package_manager/](./skills/swift_package_manager/)
- **Swift Structure (Basics):** [skills/swift_structure/](./skills/swift_structure/)
- **Swift Style:** [skills/swift_style/](./skills/swift_style/)
- **SwiftUI:** [skills/swift_swiftui/](./skills/swift_swiftui/)
- **Swift Testing:** [skills/swift_testing/](./skills/swift_testing/)

---

## 🚀 How to Install Skills

These skills are compatible with the Agent Skills standard (like the open-source Vercel [skills.sh](https://skills.sh/) ecosystem) and can be used on AI assistants like Cursor, Cline, or Context7.

### Option 1: Using `skills.sh` (npx)

If your agent environment supports [skills.sh](https://skills.sh/), you can add these skills directly using the Vercel skills CLI format. For example, to install the `swiftzilla` skill:

```bash
npx skills add SwiftZilla-org/skills/skills/swiftzilla
```
*(Adjust the owner/repo path to match the GitHub URL where this repository is hosted).*

### Option 2: Using Context7

If you use Context7 or similar platforms that support importing agent skills via repositories, you can directly import this GitHub repository or point the platform configuration to the specific skill directory you want to use (e.g., `SwiftZilla-org/skills/skills/swiftzilla`).

### Option 3: Manual Installation

To install a skill manually into an AI agent workspace (e.g., Cursor, Deepmind/Cline environments, etc.):

1. Create a `.agents/skills` or `_agents/skills` directory inside your project root.
2. Manually copy the skill directory (e.g., `skills/swiftzilla`) and its contents into your project's skills folder.
3. Make sure to read the `SKILL.md` inside each skill for any additional setup (e.g., setting up the `SWIFTZILLA_API_KEY`, granting execution permissions with `chmod +x` for binaries, etc.).

---

*Add new skills by creating a subdirectory in `skills/` with a `SKILL.md` file following the skill specification format.*
