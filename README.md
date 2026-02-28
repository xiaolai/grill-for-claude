# grill

Deep codebase interrogation — multi-angle architecture review that forces rigorous, actionable analysis.

## What it does

Grill launches 5-6 specialized agents in parallel to interrogate your codebase from every angle: architecture, error handling, security, testing, and edge cases. You pick a review style, optionally add pressure tests, and get a comprehensive report with a prioritized fixing plan.

- **6 specialized agents**: recon, architecture, error-handling, security, testing, edge-cases
- **5 review styles**: Architecture Review, Hard-Nosed Critique, Multi-Perspective Panel, ADR Style, Paranoid Mode — plus a "Select All" option
- **8 add-on pressure tests**: scale stress, hidden costs, principle violations, strangler fig migration, success metrics, before/after diagrams, assumptions audit, compact & optimize
- **Evidence-based findings**: every finding requires file paths, line references, severity tags, and effort estimates
- **Fixing plan**: phased action plan (Critical > High > Medium > Low) with dependency graph and effort totals

Part of the [xiaolai plugin marketplace](https://github.com/xiaolai/claude-plugin-marketplace).

## Installation

Add the marketplace (once):

```
/plugin marketplace add xiaolai/claude-plugin-marketplace
```

Then install:

```
/plugin install grill@xiaolai
```

| Scope | Command | Effect |
|-------|---------|--------|
| **User** (default) | `/plugin install grill@xiaolai` | Available in all your projects |
| **Project** | `/plugin install grill@xiaolai --scope project` | Shared with team via `.claude/settings.json` |
| **Local** | `/plugin install grill@xiaolai --scope local` | Only you, only this repo |

## Commands

| Command | Description |
|---------|-------------|
| `/roast` | Launch a full codebase interrogation |
| `/roast src/` | Target a specific directory |

> When installed as a plugin, the command appears as `/grill:roast`.

## How it works

1. **Recon** — the `recon` agent surveys the codebase (structure, stack, size)
2. **Choose review style** — pick from 5 styles + optional add-on pressure tests
3. **Deep dive** — 4-5 agents run in parallel, each analyzing their specialty area
4. **Synthesis** — findings are deduplicated, attributed, and formatted per the chosen style
5. **Report** — a markdown report with executive summary and phased fixing plan is saved to the target directory

## Agents

| Agent | Focus |
|-------|-------|
| `recon` | Quick codebase survey (structure, stack, dependencies) |
| `architecture` | Core architecture analysis |
| `error-handling` | Error handling & observability |
| `security` | Security surface analysis |
| `testing` | Testing & CI/CD analysis |
| `edge-cases` | Edge cases, race conditions, failure modes (Paranoid Mode) |

## Severity tags

- `[CRITICAL]` — Security vulnerability, data loss risk, correctness bug
- `[HIGH]` — Significant reliability, maintainability, or performance impact
- `[MEDIUM]` — Noticeable quality issue, not urgent
- `[LOW]` — Minor improvement, address when touching the file
- `[GOOD]` — Positive finding worth calling out

## License

MIT
