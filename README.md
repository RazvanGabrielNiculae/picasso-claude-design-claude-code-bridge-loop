<div align="center">

# 🎨 Picasso Orchestrator: Claude Design 🔄 Claude Code [Bridge Loop]

### The first gate-scored bidirectional loop between Claude Code and Claude Design.<br/>Brief → Design → Implement → Score → Refine.

<br/>

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

> **Stop guessing if your implementation matches the design. Let the loop prove it.**
>
> Picasso connects Claude Code to Claude Design in a closed feedback loop — structured brief in, verified code out, with a mathematically scored fidelity gate between them. No more "looks close enough." Either the score hits **9.0 / 10** or the loop keeps going.

---

## ⚡ Quick start — 3 steps, 30 seconds

```bash
# 01 · Install (one-liner — patches ~/.claude automatically)
curl -fsSL https://cdn.jsdelivr.net/gh/RazvanGabrielNiculae/picasso-claude-design-claude-code-bridge-loop@main/scripts/install-oneliner.sh | bash

# 02 · Verify everything is wired correctly
picasso-bridge verify --smoke

# 03 · Run your first bridge loop
/picasso --design-loop "hero cinematic for B2B SaaS" --scope complex
```

> 💡 Need a guided setup? Add `--wizard` to the install command. It walks you through gate, max rounds, and hook wiring interactively.

---

## 🔁 How it works

1. **Brief** → Describe your design goal in plain language (`/picasso --design-loop "hero for B2B SaaS"`)
2. **ASSUMPTIONS** → Picasso surfaces inferred tokens as an explicit block before any browser call — you correct inline
3. **DESIGN.md** → Structured 9-section spec is generated: colors · typography · layout · motion · responsive · accessibility
4. **Claude Design** → Picasso sends a structured prompt, captures the visual proposal via screenshot
5. **Implement** → Zero-context subagent applies only the changed `DESIGN.md` sections (~200 tok vs 2,000 naive)
6. **Render** → Desktop always · mobile only if previous responsive score < 8.0
7. **Score** → Weighted gate: ΔE colors (25%) · typography (20%) · layout (20%) · components (15%) · motion (10%) · responsive (10%)
8. **Gaps** → 3 lines max · goal-declared format: `current → target` · passed to next round
9. **Gate** → `score ≥ 9.0` → ✅ **APPROVED** · plateau → STAGNATED · else → refine and repeat from step 4

---

## 📊 By the numbers

| Metric | Value | What it means |
|---|---|---|
| 🎯 **Default gate** | **9.0 / 10** | Weighted fidelity across 6 visual criteria |
| 🔄 **Loop modes** | **5** | loop · solo · critique · reference · iterate |
| 📐 **Steps per round** | **7** | request → extract → implement → render → score → gaps → gate |
| 🧩 **Orchestration patterns** | **9+** | Token-aware, stagnation-proof by design |
| 🧠 **Karpathy principles** | **4** | Baked into the conductor — not optional extras |
| ⚡ **Token savings** | **3×** | vs. naive full-context loop (zero-context subagent + lazy reads) |

---

## 🔧 Prerequisites

| Tool | Version | Role |
|---|---|---|
| 🤖 **Claude Code** | ≥ 0.2.0 | CLI host — custom commands + subagents + hooks |
| 🎨 **Claude plan** | Pro · Max · Team · Enterprise | Required for `claude.ai/design` access |
| 🌐 **Chrome** | latest | Authenticated session on `claude.ai` |
| 🔌 **chrome-mcp** | latest | MCP browser transport — navigate, click, screenshot |
| 📐 **webdesign-mcp** | latest | Scrape tokens · render previews · compute score |
| 📦 **Node** | ≥ 18 | MCP server runtimes |
| 🛠️ **jq · bash** | any | Used by hooks and install scripts |

---

## 🔄 The loop — 7 steps per round

| Step | Name | What happens |
|---|---|---|
| `01` | 📡 **Request** | `browser_batch`: navigate → form_input → wait → screenshot(800px) → get_text |
| `02` | 🔍 **Extract** | `scrape_reference` with SHA-256 hash cache — skipped entirely if HTML unchanged |
| `03` | 🔨 **Implement** | Zero-context subagent. Only changed DESIGN.md sections. ~200 tok vs 2,000 naive. |
| `04` | 📸 **Render** | Desktop always. Mobile only if previous responsive score < 8.0. |
| `05` | 🎯 **Score** | Fast model: ΔE colors + grid pixels + token match. Standard: gap synthesis. |
| `06` | 📋 **Gaps** | 3 lines max · goal-declared format: `current → target` · 15 words each. |
| `07` | 🚪 **Gate** | total ≥ gate → ✅ APPROVED · plateau → STAGNATED · else → next round |

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

## 🏗️ Architecture — component map

| Tag | Component | Role |
|---|---|---|
| `CORE · ORCHESTRATOR` | Claude Code CLI | Hosts `/picasso`, `pdl-conductor` subagent, six lifecycle hooks |
| `CORE · DESIGN SIDE` | Claude Design (web) | Visual proposal engine driven through authenticated browser tab |
| `TRANSPORT` | chrome-mcp | MCP browser transport — navigate, click, type, upload, screenshot |
| `MEASUREMENT` | webdesign-mcp | Extracts tokens, renders candidate previews, returns weighted fidelity score |
| `PROTOCOL` | Model Context Protocol | Wire format for both MCP servers — any MCP client can swap in |
| `CONVENTION` | DESIGN.md (9 sections) | Single-source design contract: colors · typography · components · layout · motion · depth · brand · responsive · accessibility |

---

## 🎛️ Modes — 5 ways to use the bridge

| Flag | Name | Description | Best for |
|---|---|---|---|
| `--design-loop` | 🔄 **Loop** ⭐ | Full bidirectional loop. Rounds until gate is met. Default mode. | Any front-end feature from scratch |
| `--design-solo` | ⚡ Solo | Single pass: one Claude Design turn → implement → stop. | Quick exploration / prototypes |
| `--design-critique <path>` | 🔬 Critique | Claude Design audits your existing implementation and scores it. | Design-debt audit on existing code |
| `--design-reference <url>` | 🌐 Reference | Reverse-engineer design tokens from any live site. Seeds `DESIGN.md`. | "Make it feel like linear.app" |
| `--design-iterate` | ✨ Iterate | Polish pass after APPROVED. Gate auto-set to prior score + 0.3. | Motion + micro-interaction polish |

### 🆕 Design source flags (v0.2)

| Flag | Description | When to use |
|---|---|---|
| `--from-site <url>` | Extract `DESIGN.md` tokens from any live site → seed round-0 | "Build something with stripe.com's design system" |
| `--from-figma --figma <key>` | Use Figma MCP as design source instead of Claude Design | You have Figma designs ready |
| `--feedback drawbridge` | Import Drawbridge browser annotations as pre-populated gaps | Designer annotated the preview |
| `--multi-page` | Enable `SITE.md` cross-page consistency contract | Multi-page sites |

```bash
# Seed from live site (no Claude Design Pro needed for the design foundation)
/picasso --from-site https://stripe.com "pricing page for fintech"

# Use Figma as source
/picasso --from-figma --figma ABC123xyz "implement hero from Figma"

# Include designer browser annotations in the loop
/picasso --design-loop --feedback drawbridge "hero for B2B SaaS"

# Multi-page site with cross-page consistency
/picasso --design-loop --multi-page --scope mega "5-page marketing site"
```

### 📏 Scope presets — complexity-based auto-routing

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

## 🏆 Gate scoring — mathematically verified fidelity

| Criterion | Weight | How it's measured |
|---|---|---|
| 🎨 Colors | **25%** | ΔE CIE2000 palette comparison per design token |
| 🔤 Typography | **20%** | Font family · scale ratio · weight · line-height |
| 📐 Layout & spacing | **20%** | Grid alignment · margin/padding · ±2px tolerance |
| 🧩 Components | **15%** | Structural match: presence, hierarchy, nesting |
| 🎬 Motion | **10%** | Duration · easing · transition type |
| 📱 Responsive | **10%** | 8 breakpoints tested: 320px → 1920px |

> 🎯 Default gate: **9.0 / 10**. Raise to 9.5 for critical landings (increases stagnation risk). Lower to 8.5 for fast prototypes.

---

## 🧠 Context backpressure — graceful degradation, never silent failure

> The loop degrades gracefully as context fills. It never crashes silently — it checkpoints and exits `PAUSED` so you can resume in a fresh session.

| Context used | State | What happens |
|---|---|---|
| < 60% | ✅ `NORMAL` | All steps enabled — full fidelity |
| 60–75% | ⚠️ `WARN` | Skip mobile render if responsive ≥ 8.5 |
| 75–85% | 🔶 `DEGRADE` | Cache-only extraction · lazy section reads |
| 85–95% | 🔴 `SWITCH` | Fast model everywhere · 2-line gaps max |
| > 95% | 💾 `PAUSED` | `checkpoint.json` saved → exit → resumable next session |

---

## 🧬 Four Karpathy principles — baked into every round

> Not guidelines. Mechanisms. Every one maps to a concrete component in the conductor.
> Inspired by [Andrej Karpathy](https://github.com/karpathy)'s public notes on LLM coding pitfalls — specifically his observations on silent assumptions, minimal code, surgical edits, and goal-declared targets.

| # | Principle | What the loop does |
|---|---|---|
| `01` | 🤔 **Think First** | Inferred tokens surface as an explicit `ASSUMPTIONS:` block *before* the first browser call. You correct inline — zero silent assumptions. `→ ASSUMPTIONS: colors · typography · components · brand` |
| `02` | 🪶 **Simplicity** | The implementation subagent is hard-constrained: minimum code to close the gap. No refactors. No speculative features. No drive-by cleanups. `→ CONSTRAINTS: no refactor · no new features · no noise` |
| `03` | 🔬 **Surgical Edits** | Subagent touches only files tied to changed `DESIGN.md` sections. `sha256` idempotency check blocks spurious git diffs. `→ idempotent writes · changed sections only` |
| `04` | 🎯 **Goal-Led State** | Gaps are state declarations, not imperatives. The gate score is the objective function. `→ motion: 400ms → 600ms` not *"increase duration"* |

---

## 🧩 Nine orchestration patterns

> Every pattern exists to solve a specific failure mode in naive "loop and hope" approaches.

| # | Pattern | Problem it solves | Impact |
|---|---|---|---|
| `01` | 📝 **Structured prompts** | Prose prompts are verbose and inconsistent | **5× compression** on Round-N prompts |
| `02` | #️⃣ **Content-hash cache** | `scrape_reference` called even on identical output | Saves **1 MCP call/round** on average |
| `03` | 🔏 **Fingerprint dedup** | Same visual output, different HTML → infinite loop | **Instant STAGNATED** exit — no wasted rounds |
| `04` | 📖 **Lazy section reads** | Reading all 9 DESIGN.md sections every round | **~50 tok vs 450 tok** after round 1 |
| `05` | 🚦 **Model routing** | Large model used for simple arithmetic scoring | **~40% cost reduction** per round |
| `06` | 📱 **Adaptive rendering** | Mobile render every round even when stable | Saves **1 render call** in most rounds after round 2 |
| `07` | 🧹 **Zero-context subagent** | Implementer inherits full 2,000 tok loop history | **~200 tok vs ~2,000 tok** — 10× cleaner context |
| `08` | ✅ **Idempotency check** | Files re-written with no actual change → git noise | **Clean diffs** — unchanged files never touched |
| `09` | 🛡️ **Context backpressure** | Loop crashes or degrades silently at context limit | **Resumable sessions** via checkpoint |

---

## 🪝 Lifecycle hooks — full control over every event

> Six hooks. Drop them in `~/.claude/hooks/`. Edit a stub to activate. Delete to disable.

| Hook | Fires on | What it does |
|---|---|---|
| `pdl-autodetect` | 🔔 `UserPromptSubmit` | Detects handoff phrases (`"claude.ai/design"`, `"export"`) and auto-suggests `/picasso` |
| `pdl-pre-round` | ⏱️ Pre-round | Budget guard — aborts if `.pdl/` > 50 MB or remaining budget < round estimate |
| `pdl-post-round` | 📊 Post-round | Cache report + `economy.jsonl` append · `exit 2` = force APPROVED · `exit 3` = force abort |
| `pdl-stagnation` | 📉 Stagnation | Customizable — lower gate, switch mode, or send alert on score plateau |
| `pdl-approved` | ✅ Approved | Customizable — auto-commit, open PR, send Slack/Discord notification |
| `pdl-failed` | ❌ Failed | Customizable — alert, cleanup, save trajectory log for post-mortem |

See [docs/HOOKS.md](docs/HOOKS.md) for full reference.

---

## 📦 Install

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

## 📁 Output structure

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

## 🚦 Exit codes

| Code | Meaning |
|---|---|
| `✅ APPROVED` | score ≥ gate — code implemented, `.pdl/APPROVED.md` written |
| `📉 STAGNATED` | 2 rounds without progress, or fingerprint dedup match |
| `🔚 EXHAUSTED` | `rounds_max` reached without hitting gate |
| `⛔ EARLY_ABORT` | trajectory analysis: gate mathematically unreachable |
| `💾 PAUSED` | context > 95% — checkpoint saved, resumable in new session |
| `🔒 BLOCKED` | prerequisite missing (Chrome MCP / Claude Design / plan) |
| `❌ ERROR` | technical failure — see `.pdl/error.log` |

---

## 🔌 Companion tools

Picasso handles the loop. These tools extend it at the **input**, **feedback**, and **scale** layers.

| Tool | Layer | What it adds |
|---|---|---|
| [bergside/design-md-chrome](https://github.com/bergside/design-md-chrome) ⭐542 | Input | Extract `DESIGN.md` from any live site → `--from-site` |
| [Figma MCP](https://github.com/figma/mcp-server-guide) | Input | Figma designs as design source → `--from-figma` |
| [breschio/drawbridge](https://github.com/breschio/drawbridge) | Feedback | Browser annotations → DOM-anchored gaps → `--feedback drawbridge` |
| [HermeticOrmus/LibreUIUX-Claude-Code](https://github.com/HermeticOrmus/LibreUIUX-Claude-Code) | Scale | 152 UI/UX agents for complex builds |
| [wilwaldon/Frontend-Design-Toolkit](https://github.com/wilwaldon/Claude-Code-Frontend-Design-Toolkit) | Scale | Curated toolkit: tokens, Playwright, accessibility |
| [hemangjoshi37a/claude-code-frontend-dev](https://github.com/hemangjoshi37a/claude-code-frontend-dev) | Visual QA | Post-APPROVED visual testing with closed-loop fixes |

See **[docs/companion-tools.md](docs/companion-tools.md)** for integration guides.

---

## 📋 Changelog

### v0.2.0 — 2026-04 · Design sources + feedback
- Adds: `--from-site` (design-md-chrome pattern), `--from-figma` (Figma MCP source)
- Adds: `--feedback drawbridge` (browser annotation integration)
- Adds: `--multi-page` + `SITE.md` cross-page consistency (jezweb/design-loop pattern)
- Adds: visual scoring tiers (PASS / PASS WITH NOTES / ITERATE / FAIL)
- Adds: expanded fallback matrix for all new input modes
- Docs: `docs/companion-tools.md` integration guide

### v0.1.0 — 2026-04 · First public release
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

## 📚 Docs

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

## 🗑️ Uninstall

```bash
bash scripts/uninstall.sh
```

Then remove the hook block from `~/.claude/settings.json` manually.

---

<div align="center">
<sub>Not affiliated with Anthropic. "Claude", "Claude Code", and "Claude Design" are trademarks of Anthropic.<br/>
This project only orchestrates user-owned sessions of those tools. · MIT License</sub>
</div>
