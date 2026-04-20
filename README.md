# Picasso · Claude Design ↔ Claude Code Bridge Loop

[![Visual Docs](https://img.shields.io/badge/Visual%20Docs-View%20Site-4F8EF7?style=flat-square&logo=github)](https://razvanGabrielNiculae.github.io/picasso-claude-design-claude-code-bridge-loop/)

A bidirectional loop between **Claude Code** (local coding agent) and **Claude Design** (web design tool at `claude.ai/design`). Drive a design round in the browser, have Claude Code implement it locally, score the fidelity automatically, refine, and repeat until a quality gate is hit.

```
 ┌───────────────────┐      prompt      ┌──────────────────────┐
 │ /picasso          │ ───────────────► │ Claude Design        │
 │ (Claude Code)     │                  │ (claude.ai/design)   │
 │                   │ ◄─────────────── │                      │
 └───────────────────┘    tokens+png    └──────────────────────┘
         │                                         ▲
         │ implement + render + score              │
         ▼                                         │
  impl preview ──► ΔE / layout / motion ──► gap refine loop
```

## What you get

- **`/picasso`** — creative front-end orchestrator command for Claude Code.
- **`/picasso --design-loop`** — activates the bidirectional PDL (Picasso Design Loop).
- **`pdl-conductor`** — dedicated agent that manages rounds, scoring, and gate enforcement.
- **`pdl-autodetect` hook** — auto-detects a Claude Design handoff in a user prompt and suggests the loop.
- Installers for macOS / Linux / WSL / Git-Bash and Windows PowerShell.

## Status

Research / early preview. Expect the design loop to be usable only on a **Claude Pro / Max / Team / Enterprise** account (Claude Design is a research preview restricted to those plans).

## Prerequisites

| Tool | Why | Link |
|---|---|---|
| Claude Code | Host for `/picasso` | https://claude.ai/code |
| Chrome MCP | Browser automation for claude.ai/design | https://claude.ai/chrome |
| webdesign-mcp | Token extraction + preview render + scoring | https://github.com/Bendix-ai/webdesign-mcp |
| Claude Pro / Max / Team / Enterprise | Access to Claude Design | https://claude.com/pricing |

## Install

### One-liner (macOS / Linux / WSL / Git-Bash)

```bash
curl -fsSL https://cdn.jsdelivr.net/gh/RazvanGabrielNiculae/picasso-claude-design-claude-code-bridge-loop@main/scripts/install-oneliner.sh | bash
```

Interactive wizard (asks for gate, rounds, hook auto-wiring):

```bash
curl -fsSL https://cdn.jsdelivr.net/gh/RazvanGabrielNiculae/picasso-claude-design-claude-code-bridge-loop@main/scripts/install-oneliner.sh | bash -s -- --wizard
```

### Manual clone (macOS / Linux / WSL / Git-Bash)

```bash
git clone https://github.com/RazvanGabrielNiculae/picasso-claude-design-claude-code-bridge-loop.git
cd picasso-claude-design-claude-code-bridge-loop
bash scripts/install.sh --wizard
bash scripts/verify.sh --smoke
```

### Windows (PowerShell)

```powershell
git clone https://github.com/RazvanGabrielNiculae/picasso-claude-design-claude-code-bridge-loop.git
cd picasso-claude-design-claude-code-bridge-loop
pwsh -File scripts\install.ps1
pwsh -File scripts\verify.ps1
```

The installer patches `~/.claude/settings.json` automatically (with a timestamped backup). Use `--no-hook` to skip auto-wiring if you prefer to add the block manually.

## Use

```bash
# Classic — just the /picasso orchestrator
/picasso hero cinematic for a B2B SaaS, dark elite

# Bridge loop (default mode) — Claude Code <-> Claude Design, gate 9.0, max 6 rounds
/picasso --design-loop hero cinematic for a B2B SaaS, dark elite

# One-shot: a single Claude Design pass → code, no iteration
/picasso --design-solo sticky promo banner, warm palette

# Critique: Claude Design audits an existing implementation
/picasso --design-critique ./src/components/hero

# Reference: reverse-engineer tokens from a real site, then brief
/picasso --design-reference https://linear.app

# Iterate: a polish pass after an earlier APPROVED loop
/picasso --design-iterate tighten motion choreography

# Scope presets (complexity-based routing)
/picasso --scope simple  "pricing toggle"         # gate 8.0, 3 rounds
/picasso --scope medium  "pricing page section"   # gate 8.5, 5 rounds
/picasso --scope complex "full marketing landing" # gate 9.0, 7 rounds + fallback-manual
/picasso --scope mega    "marketing site (5 pages)" # gate 9.0, 10 rounds
```

When the hook detects a handoff pattern in your prompt (e.g. `claude.ai/design`, `Claude Design export`, `handoff from Claude Design`), it suggests the loop automatically.

### Lifecycle hooks

The installer drops optional stubs into `~/.claude/hooks/`:

- `pdl-pre-round.sh` — before every round
- `pdl-post-round.sh` — after scoring (can force APPROVED or abort)
- `pdl-stagnation.sh` — when scores oscillate
- `pdl-approved.sh` — on success (auto-commit, open PR, notify)
- `pdl-failed.sh` — on exhaustion / block / error

Edit a stub to activate it, or delete it to disable. See [docs/HOOKS.md](docs/HOOKS.md).

## Scoring

The gate is a weighted fidelity score between Claude Design's output and your local implementation:

| Criterion | Weight | Method |
|---|---|---|
| Colors | 25% | Dominant palette + ΔE CIE2000 per token |
| Typography | 20% | Family / scale / weight / line-height |
| Layout & spacing | 20% | Grid + margins (±2px tolerance) |
| Components | 15% | Structural match |
| Motion | 10% | Duration / easing / transitions |
| Responsive | 10% | 8 breakpoints |

Default gate is **9.0**. Raise to 9.5 for critical landings (higher stagnation risk).

## Docs

- [Architecture](docs/ARCHITECTURE.md)
- [Installation](docs/INSTALLATION.md)
- [Bridge loop walkthrough](docs/BRIDGE-LOOP.md)
- [Modes & scope presets](docs/MODES.md)
- [Lifecycle hooks](docs/HOOKS.md)
- [Gate scoring details](docs/GATE-SCORING.md)
- [Design patterns (9 orchestration principles)](docs/DESIGN-PATTERNS.md)
- [Token & performance optimization](docs/TOKEN-OPTIMIZATION.md)
- [Prompt templates](docs/PROMPT-TEMPLATES.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)

## Uninstall

```bash
bash scripts/uninstall.sh
```

Then remove the hook block from `~/.claude/settings.json` manually.

## License

MIT — see [LICENSE](LICENSE).

## Disclaimer

Not affiliated with Anthropic. "Claude", "Claude Code", and "Claude Design" are trademarks of Anthropic. This project only orchestrates user-owned sessions of those tools.
