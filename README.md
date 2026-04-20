<div align="center">

<img src="docs/banner.svg" alt="Picasso · Claude Design ↔ Claude Code Bridge Loop" width="100%"/>

<br/><br/>

[![GitHub](https://img.shields.io/badge/GITHUB-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/RazvanGabrielNiculae/picasso-claude-design-claude-code-bridge-loop)
[![Visual Docs](https://img.shields.io/badge/VISUAL%20DOCS-ff2d95?style=for-the-badge&logo=githubpages&logoColor=white)](https://RazvanGabrielNiculae.github.io/picasso-claude-design-claude-code-bridge-loop/)

<br/>

[![Stars](https://img.shields.io/github/stars/RazvanGabrielNiculae/picasso-claude-design-claude-code-bridge-loop?style=for-the-badge&logo=github&color=181717&logoColor=white&label=STARS)](https://github.com/RazvanGabrielNiculae/picasso-claude-design-claude-code-bridge-loop/stargazers)
[![Gate Score](https://img.shields.io/badge/GATE%20SCORE-9.0%2F10-ffd83d?style=for-the-badge&labelColor=0a0508&color=ffd83d)](docs/GATE-SCORING.md)
[![Patterns](https://img.shields.io/badge/PATTERNS-9%20orchestration-5ce1ff?style=for-the-badge&labelColor=0a0508&color=5ce1ff)](docs/DESIGN-PATTERNS.md)
[![License](https://img.shields.io/badge/LICENSE-MIT-7cf0a0?style=for-the-badge&labelColor=0a0508)](LICENSE)

<br/>

[![Claude Code](https://img.shields.io/badge/CLAUDE%20CODE-compatible-ff4fa8?style=for-the-badge&labelColor=0a0508)](https://claude.ai/code)
[![Claude Design](https://img.shields.io/badge/CLAUDE%20DESIGN-bridge-ffd83d?style=for-the-badge&labelColor=0a0508)](https://claude.ai/design)
[![Karpathy](https://img.shields.io/badge/KARPATHY-×4%20principles-5ce1ff?style=for-the-badge&labelColor=0a0508)](docs/DESIGN-PATTERNS.md#philosophical-foundation)
[![Modes](https://img.shields.io/badge/MODES-5%20variants-ff4fa8?style=for-the-badge&labelColor=0a0508)](docs/MODES.md)

</div>

---

A bidirectional loop between **Claude Code** (local coding agent) and **Claude Design** (`claude.ai/design`). Send a structured brief → receive a design → implement locally → score fidelity → refine → repeat until a quality gate is hit.

---

## Quick start

```bash
# 01 · Install
curl -fsSL https://cdn.jsdelivr.net/gh/RazvanGabrielNiculae/picasso-claude-design-claude-code-bridge-loop@main/scripts/install-oneliner.sh | bash

# 02 · Verify
picasso-bridge verify --smoke

# 03 · Run
/picasso --design-loop "hero cinematic for B2B SaaS" --scope complex
```

---

## Stats

| | |
|---|---|
| **9.0** | Default gate — weighted fidelity across 6 criteria |
| **5** | Modes — loop · solo · critique · reference · iterate |
| **7** | Steps per round — request → extract → implement → render → score → gaps → gate |
| **9+** | Orchestration patterns — token-aware by design |

---

## Prerequisites

| Tool | Version | Role |
|---|---|---|
| Claude Code | ≥ 0.2.0 | CLI host — custom commands + subagents + hooks |
| Claude plan | Pro · Max · Team · Enterprise | Access to claude.ai/design |
| Chrome | latest | Authenticated session on claude.ai |
| chrome-mcp | latest | MCP browser transport |
| webdesign-mcp | latest | Scrape · render · score |
| Node | ≥ 18 | MCP server runtimes |
| jq · bash | any | Used by hooks and install scripts |

---

## The loop — 7 steps per round

| Step | Name | What happens |
|---|---|---|
| 01 | **Request** | `browser_batch`: navigate → form_input → wait → screenshot(800px) → get_text |
| 02 | **Extract** | `scrape_reference` with SHA-256 hash cache — skip if HTML unchanged |
| 03 | **Implement** | Zero-context subagent. Only changed DESIGN.md sections (~200 tok). |
| 04 | **Render** | Desktop always. Mobile only if previous responsive score < 8.0. |
| 05 | **Score** | Fast model for ΔE + grid + tokens. Standard for gap synthesis. |
| 06 | **Gaps** | 3 lines · goal-declared: `current → target` · 15 words each. |
| 07 | **Gate** | total ≥ gate → APPROVED · stagnation → STAGNATED · else → next round |

```
 ┌───────────────────┐    structured prompt    ┌──────────────────────┐
 │ /picasso          │ ──────────────────────► │ Claude Design        │
 │ (Claude Code)     │                          │ (claude.ai/design)   │
 │                   │ ◄────────────────────── │                      │
 └───────────────────┘    tokens + preview      └──────────────────────┘
         │                                               ▲
         │ implement · render · score (steps 03-05)      │
         ▼                                               │
  impl preview ──► ΔE / layout / motion ──► gap refine ─┘
```

---

## Architecture — component map

| Tag | Component | Role |
|---|---|---|
| `CORE · ORCHESTRATOR` | Claude Code CLI | Hosts `/picasso`, `pdl-conductor` subagent, six lifecycle hooks |
| `CORE · DESIGN SIDE` | Claude Design (web) | Visual proposal engine driven through authenticated browser tab |
| `TRANSPORT` | chrome-mcp | MCP browser transport — navigate, click, type, upload, screenshot |
| `MEASUREMENT` | webdesign-mcp | Extracts tokens, renders candidate previews, returns weighted fidelity score |
| `PROTOCOL` | Model Context Protocol | Wire format for both MCP servers — any MCP client can swap in |
| `CONVENTION` | DESIGN.md (9 sections) | Single-source design contract: colors · typography · components · layout · motion · depth · brand · responsive · accessibility |

---

## Modes

| Flag | Name | Description | Best for |
|---|---|---|---|
| `--design-loop` | **Loop** ⭐ | Bidirectional loop. Runs rounds until gate is met. | Any front-end feature from scratch |
| `--design-solo` | Solo | Single pass: one Claude Design turn → implement → stop. | Quick exploration / prototypes |
| `--design-critique <path>` | Critique | Claude Design audits your existing implementation. | Design-debt audit on existing code |
| `--design-reference <url>` | Reference | Reverse-engineer tokens from a live site. Seeds DESIGN.md. | "Feel like linear.app" |
| `--design-iterate` | Iterate | Polish pass after APPROVED. Gate = prior + 0.3. | Motion + micro-interaction polish |

### Scope presets

| Scope | Gate | Rounds | Fallback manual | Example |
|---|---|---|---|---|
| `--scope simple` | 8.0 | 3 | no | pricing toggle |
| `--scope medium` | 8.5 | 5 | no | pricing section |
| `--scope complex` | 9.0 | 7 | yes | full landing page |
| `--scope mega` | 9.0 | 10 | yes | 5-page site |

```bash
/picasso --design-loop "hero cinematic for a B2B SaaS, dark elite"
/picasso --design-solo "sticky promo banner, warm palette"
/picasso --design-critique ./src/components/hero
/picasso --design-reference https://linear.app
/picasso --design-iterate "tighten motion choreography"
/picasso --scope complex "full marketing landing"
```

---

## Gate scoring

| Criterion | Weight | Method |
|---|---|---|
| Colors | **25%** | ΔE CIE2000 palette comparison per token |
| Typography | **20%** | Family · scale · weight · line-height |
| Layout & spacing | **20%** | Grid alignment · ±2px tolerance |
| Components | **15%** | Structural match: presence + hierarchy |
| Motion | **10%** | Duration · easing · transitions |
| Responsive | **10%** | 8 breakpoints: 320 → 1920 |

Default gate: **9.0 / 10**. Raise to 9.5 for critical landings (higher stagnation risk).

---

## Backpressure — 5 levels

| Context used | State | Action |
|---|---|---|
| < 60% | `NORMAL` | All steps enabled |
| 60–75% | `WARN` | Skip mobile render if responsive ≥ 8.5 |
| 75–85% | `DEGRADE` | Cache-only extraction; lazy reads |
| 85–95% | `SWITCH` | Fast model everywhere; 2-line gaps |
| > 95% | `PAUSED` | `checkpoint.json` → exit → resumable in new session |

---

## Four Karpathy principles

Baked into every round of the conductor:

| # | Principle | Mechanism |
|---|---|---|
| 01 | **Think First** | Every inferred token surfaces as an explicit `ASSUMPTIONS:` block before the first browser call. The user corrects it inline — no silent assumptions propagate. `→ ASSUMPTIONS: colors · typography · components · brand` |
| 02 | **Simplicity** | The implementation subagent is constrained to the minimum code that closes the gap. No adjacent refactors, no speculative features, no drive-by cleanups. `→ CONSTRAINTS: no refactor · no new features · no noise` |
| 03 | **Surgical Edits** | The subagent touches only files tied to changed DESIGN.md sections. A sha256 idempotency check guarantees no spurious git diffs. `→ idempotent writes · changed sections only` |
| 04 | **Goal-Led State** | Gaps are state declarations, not imperatives. The gate score is the objective function — the loop iterates toward it. `→ motion: 400ms → 600ms` (not "increase duration") |

---

## Nine orchestration patterns

| # | Pattern | What it does | Source |
|---|---|---|---|
| 01 | **Structured prompts** | Key:value blocks, never prose. 5× compression over naive round-N prompts. | pattern · core |
| 02 | **Content-hash cache** | Skip `scrape_reference` when design HTML hash is unchanged from the prior round. | fingerprint dedup |
| 03 | **Fingerprint dedup** | `hash(tokens + score)` identical across rounds → STAGNATED. Early exit, no wasted calls. | pattern · core |
| 04 | **Lazy section reads** | Read only the DESIGN.md sections that changed. Average: 2 of 9 sections per round. | pattern · local |
| 05 | **Model routing** | Fast for scoring (deterministic ΔE). Standard for gap synthesis. Large only on stagnation recovery. | pattern · core |
| 06 | **Adaptive rendering** | Skip mobile render whenever prior responsive score ≥ 8.0. Desktop always on. | pattern · local |
| 07 | **Zero-context subagent** | Implementation gets a scoped ~200 tok brief, not the 2,000 tok parent context. | pattern · agentic |
| 08 | **Idempotency check** | sha256 of target vs. pending write. Unchanged files never touched — clean diffs. | pattern · core |
| 09 | **Context backpressure** | Five degradation levels. Checkpoint on PAUSED. Resumable in a new session. | pattern · core |

---

## Lifecycle hooks

| Hook | Fires | Description |
|---|---|---|
| `pdl-autodetect` | `UserPromptSubmit` | Suggests `/picasso` when handoff phrases ("claude.ai/design", "export") appear in the prompt |
| `pdl-pre-round` | Pre-round | Budget guard. Aborts if `.pdl/` artifacts exceed 50 MB or remaining budget < round estimate |
| `pdl-post-round` | Post-round | Cache report + `economy.jsonl` append. `exit 2` = force APPROVED · `exit 3` = force abort |
| `pdl-stagnation` | Stagnation | User-definable. Lower gate, switch mode, or alert. Fires on score plateau or fingerprint match |
| `pdl-approved` | Approved | User-definable. Auto-commit, open PR, send notification |
| `pdl-failed` | Failed | User-definable. Alert, cleanup, log trajectory for post-mortem |

The installer drops stubs into `~/.claude/hooks/`. Edit to activate, delete to disable. See [docs/HOOKS.md](docs/HOOKS.md).

---

## Install

### One-liner (macOS / Linux / WSL / Git-Bash)

```bash
curl -fsSL https://cdn.jsdelivr.net/gh/RazvanGabrielNiculae/picasso-claude-design-claude-code-bridge-loop@main/scripts/install-oneliner.sh | bash
```

Wizard mode (prompts for gate, rounds, hook wiring):
```bash
... | bash -s -- --wizard
```

### Manual clone

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

The installer patches `~/.claude/settings.json` automatically (timestamped backup). Use `--no-hook` to skip auto-wiring.

---

## Output structure

```
.pdl/
├── round-0/
│   ├── DESIGN.md        ← inferred tokens + ASSUMPTIONS block
│   └── prompt.md        ← Round-0 brief (~250 tok)
├── round-1/
│   ├── prompt.md        ← Round-N delta (~100 tok)
│   ├── design-output.png
│   ├── tokens.json
│   ├── impl-desktop.png
│   ├── impl-mobile.png  ← only if responsive < 8.0
│   ├── score.json
│   └── gaps.md
└── APPROVED.md          ← or FAILED.md
```

---

## Exit codes

| Code | Meaning |
|---|---|
| `APPROVED` | score ≥ gate, code implemented |
| `STAGNATED` | 2 rounds without progress (or fingerprint dedup match) |
| `EXHAUSTED` | `rounds_max` reached without hitting gate |
| `EARLY_ABORT` | trajectory analysis: gate unreachable |
| `PAUSED` | context > 95%, checkpoint saved, resumable |
| `BLOCKED` | prerequisite missing (Chrome MCP / Claude Design access) |
| `ERROR` | technical failure — see `.pdl/error.log` |

---

## Changelog

### v1.0 — 2026-04 · First public release
- Unified public repo: v0.1 narrative + v0.2 operator additions
- Adds: context backpressure · 10 token-optimizations · Karpathy principles · 5 modes + 4 scope presets
- Adds: model routing · zero-context subagent · trajectory abort · idempotent writes
- Adds: 6 lifecycle hooks · wizard installer · economy.jsonl tracking
- Adds: reference mode · iterate mode · critique mode

### v0.2 — operator-grade internals
- Conductor phases 1→4 · ASSUMPTIONS surfacing · DESIGN.md delta reads
- STAGNATED · EARLY_ABORT · PAUSED states · fingerprint deduplication
- Budget preflight · economy.jsonl · daily cap enforcement

### v0.1 — initial bridge
- `/picasso --design-loop` command · `pdl-conductor` agent
- 6 round steps · gate scoring · `pdl-autodetect` hook
- One-liner installer (macOS / Linux / WSL / PowerShell)

---

## Docs

| | |
|---|---|
| [Architecture](docs/ARCHITECTURE.md) | System overview and component map |
| [Bridge loop walkthrough](docs/BRIDGE-LOOP.md) | Phase-by-phase execution |
| [Modes & scope presets](docs/MODES.md) | 5 loop variants |
| [Gate scoring](docs/GATE-SCORING.md) | Weighted criteria + tuning guide |
| [Design patterns](docs/DESIGN-PATTERNS.md) | 9 orchestration patterns + Karpathy |
| [Token optimization](docs/TOKEN-OPTIMIZATION.md) | 3× overhead reduction |
| [Lifecycle hooks](docs/HOOKS.md) | Hook system reference |
| [Prompt templates](docs/PROMPT-TEMPLATES.md) | Round-0 and Round-N formats |
| [Installation](docs/INSTALLATION.md) | Full install guide |
| [Troubleshooting](docs/TROUBLESHOOTING.md) | Common issues + fixes |

---

## Uninstall

```bash
bash scripts/uninstall.sh
```

Then remove the hook block from `~/.claude/settings.json` manually.

---

<div align="center">
<sub>Not affiliated with Anthropic. "Claude", "Claude Code", and "Claude Design" are trademarks of Anthropic.<br/>
This project only orchestrates user-owned sessions of those tools. · MIT License</sub>
</div>
