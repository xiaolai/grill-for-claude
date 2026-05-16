# grill

[![Validated by NLPM](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/xiaolai/grill-for-claude/main/nlpm-badge.json)](https://github.com/xiaolai/grill-for-claude/blob/main/nlpm-badge.json)

Deep codebase interrogation — multi-angle architecture review that forces rigorous, actionable analysis. **Works in both Claude Code and OpenAI Codex CLI.**

## What it does

Grill launches 5-6 specialized analysis units in parallel to interrogate your codebase from every angle: architecture, error handling, security, testing, and edge cases. You pick a review style, optionally add pressure tests, and get a comprehensive report with a prioritized fixing plan.

- **6 specialized analysis units**: recon, architecture, error-handling, security, testing, edge-cases (shipped as agents under Claude Code, as skills under Codex)
- **5 review styles**: Architecture Review, Hard-Nosed Critique, Multi-Perspective Panel, ADR Style, Paranoid Mode — plus a "Select All" option
- **8 add-on pressure tests**: scale stress, hidden costs, principle violations, strangler fig migration, success metrics, before/after diagrams, assumptions audit, compact & optimize
- **Evidence-based findings**: every finding requires file paths, line references, severity tags, and effort estimates
- **Fixing plan**: phased action plan (Critical > High > Medium > Low) with dependency graph and effort totals

Part of the [xiaolai plugin marketplace](https://github.com/xiaolai/claude-plugin-marketplace).

## Installation

### Claude Code

Add the marketplace once, then install:

```
/plugin marketplace add xiaolai/claude-plugin-marketplace
/plugin install grill@xiaolai
```

> **Install fails with "Plugin not found in marketplace 'xiaolai'"?** Your local marketplace clone is stale. Run `claude plugin marketplace update xiaolai` and retry — `plugin install` does not auto-refresh.

| Scope | Command | Effect |
|-------|---------|--------|
| **User** (default) | `/plugin install grill@xiaolai` | Available in all your projects |
| **Project** | `/plugin install grill@xiaolai --scope project` | Shared with team via `.claude/settings.json` |
| **Local** | `/plugin install grill@xiaolai --scope local` | Only you, only this repo |

### OpenAI Codex CLI

Codex installs plugins from a marketplace via an **in-session TUI**, not a shell command. There is no `codex plugin install` verb.

**One-time setup** (shell):

```bash
codex plugin marketplace add xiaolai/claude-plugin-marketplace
```

**Per-plugin install** (inside a Codex session):

1. Start a session: `codex` (in your project directory)
2. Type `/plugins` — opens the plugin TUI
3. Find grill in the `xiaolai` marketplace, install/enable it

## Usage

### In Claude Code: slash command

```
/grill:roast
```

Optionally target a subdirectory: `/grill:roast src/`

### In OpenAI Codex CLI: skill invocation

Codex uses the `$skill-name` syntax, not slash commands. Type either:

```
$grill-roast
```

Or just describe the task in natural language ("do a multi-angle audit of this codebase") and Codex's auto-match will load the skill from its description.

> **Why the difference?** Claude Code maps a plugin's `commands/*.md` files to slash commands like `/grill:roast`. Codex deprecated custom prompts in favor of skills (description-matched on intent), so the same orchestration is shipped as a skill under Codex's layout.

## How it works

1. **Recon** — the recon unit surveys the codebase (structure, stack, size)
2. **Choose review style** — pick from 5 styles + optional add-on pressure tests
3. **Deep dive** — 4-5 analysis units run, each analyzing their specialty area (parallel under Claude Code, sequential under Codex)
4. **Synthesis** — findings are deduplicated, attributed, and formatted per the chosen style
5. **Report** — a markdown report with executive summary and phased fixing plan is saved to the target directory

## Analysis units

| Unit | Focus | Claude name | Codex name |
|------|-------|-------------|------------|
| Recon | Quick codebase survey (structure, stack, dependencies) | `recon` agent | `$grill-recon` skill |
| Architecture | Core architecture analysis | `architecture` agent | `$grill-architecture` skill |
| Error handling | Error handling & observability | `error-handling` agent | `$grill-error-handling` skill |
| Security | Security surface analysis | `security` agent | `$grill-security` skill |
| Testing | Testing & CI/CD analysis | `testing` agent | `$grill-testing` skill |
| Edge cases | Race conditions, boundary values, failure modes (Paranoid Mode) | `edge-cases` agent | `$grill-edge-cases` skill |

All units share the `grill-core` skill, which defines severity tags, finding format, evidence standards, and the untrusted-input rule.

## Severity tags

- `[CRITICAL]` — Security vulnerability, data loss risk, correctness bug
- `[HIGH]` — Significant reliability, maintainability, or performance impact
- `[MEDIUM]` — Noticeable quality issue, not urgent
- `[LOW]` — Minor improvement, address when touching the file
- `[GOOD]` — Positive finding worth calling out

## License

ISC
