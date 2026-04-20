# Companion Tools

Picasso is a focused loop orchestrator — it does one thing well: bridge Claude Code and Claude Design with gate-scored fidelity. These external tools extend the pipeline at the **input**, **feedback**, and **scale** layers without coupling the core loop to third-party dependencies.

---

## Input Layer — seed DESIGN.md before the loop starts

### [bergside/design-md-chrome](https://github.com/bergside/design-md-chrome) ⭐ 542 — MIT

**What it does:** Chrome extension that scans any live website and exports its design system as a `DESIGN.md` or `SKILL.md` file — typography, color palette, spacing, border-radius, shadows, animations, WCAG contrast.

**How it integrates with Picasso:**

```bash
# 1. Open the target site in Chrome, run the extension → download DESIGN.md
# 2. Feed it to Picasso as the round-0 foundation:
/picasso --design-loop --design-ref ./DESIGN.md "hero like stripe.com but for fintech"

# Or use the --from-site flag (Picasso runs the extraction automatically via webdesign-mcp):
/picasso --from-site https://stripe.com "hero for fintech"
```

**Why it matters:** Skips the speculative Round-0 brief. Real production tokens = 1–2 fewer rounds to gate.

---

### [figma/mcp-server-guide](https://github.com/figma/mcp-server-guide) + [arinspunk/claude-talk-to-figma-mcp](https://github.com/arinspunk/claude-talk-to-figma-mcp)

**What it does:** Bidirectional Figma ↔ Claude Code via MCP. Read components, extract variables, modify designs programmatically.

**How it integrates with Picasso:**

```bash
# Use Figma as design source instead of Claude Design:
/picasso --from-figma --figma <file-key> "implement the hero component from Figma"

# In pdl-conductor: PHASE 3 REQUEST replaces browser_batch with:
#   mcp__Figma__get_screenshot(node_id) → design-output.png
#   mcp__Figma__get_variable_defs()     → tokens for DESIGN.md
```

**Install:**
```bash
# Official Figma plugin for Claude Code:
claude plugin install figma@claude-plugins-official
```

---

## Feedback Layer — close the loop with visual annotations

### [breschio/drawbridge](https://github.com/breschio/drawbridge) — MIT

**What it does:** Chrome extension for browser annotations. Press `C` → annotate any element on your running implementation → comments + DOM selectors exported to `moat-tasks.md`. Claude Code (or Cursor) reads the file and processes annotations in step/batch/yolo mode.

**How it integrates with Picasso:**

```bash
# After each PDL round, annotate on the preview:
#   1. Open implementation preview in Chrome
#   2. Drawbridge: annotate issues (press C, click element, type comment)
#   3. Drawbridge: export → moat-tasks.md

# Pass annotations to next PDL round:
/picasso --design-loop --feedback drawbridge "hero for B2B SaaS"
# pdl-conductor reads moat-tasks.md before each REQUEST → merges into gaps
```

**Why it matters:** Replaces vague text feedback ("looks off") with precise DOM-anchored targets. Gaps become specific.

---

## Scale Layer — UI/UX skill routing for complex builds

### [HermeticOrmus/LibreUIUX-Claude-Code](https://github.com/HermeticOrmus/LibreUIUX-Claude-Code) — MIT

**What it does:** 152 specialized UI/UX agents, 70 domain plugins, 76 slash commands, 74 skills — built for Claude Code. Covers: design critique, accessibility verification, responsive checking, component generation, design system enforcement.

**How it integrates with Picasso:**

Not a direct PDL integration. Use alongside Picasso for complex builds:

```bash
# Before Picasso loop: run design-system audit
/design-system-audit ./src

# After Picasso APPROVED: accessibility check
/accessibility-check ./src --wcag AA

# During PHASE 3 IMPLEMENT: activate relevant agents
# (if you have LibreUIUX installed in ~/.claude/agents/)
```

**Relevant agents for PDL workflows:**
- `ui-validator` — structural match check
- `responsive-checker` — 8-breakpoint audit
- `design-critic` — visual gap identification
- `a11y-enforcer` — WCAG 2.2 AA verification

---

### [wilwaldon/Claude-Code-Frontend-Design-Toolkit](https://github.com/wilwaldon/Claude-Code-Frontend-Design-Toolkit) — 79★

**What it does:** Curated toolkit: Figma MCP, design tokens, Tailwind, motion libraries, Playwright MCP, accessibility skills.

**Recommended stack from the toolkit for Picasso projects:**

| Layer | Tool |
|---|---|
| Design source | Figma MCP Server |
| Token system | Design Tokens + Tailwind CSS Kit |
| Testing | Playwright MCP + Chrome DevTools |
| Polish | Baseline UI + motion/performance skills |

**Install as Context7 MCP context source:**
```bash
# Adds design vocabulary to Claude Code session context
claude mcp add context7
```

---

## Visual Testing

### [hemangjoshi37a/claude-code-frontend-dev](https://github.com/hemangjoshi37a/claude-code-frontend-dev) — MIT

**What it does:** Closed-loop visual testing. Claude 4.5 Sonnet sees your UI through screenshots + Playwright. Automated 5-iteration fix loop. Scoring tiers:

| Score | Tier | Action |
|---|---|---|
| 95–100 | PASS | Ship |
| 85–94 | PASS WITH NOTES | Optional polish |
| 65–84 | ITERATE | Auto-fix cycle |
| < 65 | FAIL | Investigate root cause |

**How it integrates with Picasso:**

The scoring tiers above are adopted in `pdl-conductor.md` as the visual tier label system. For deep visual validation after PDL APPROVED, run this plugin to catch sub-pixel issues that ΔE comparison misses.

---

## Quick reference

| Tool | Layer | Requires | When to use |
|---|---|---|---|
| design-md-chrome | Input | Chrome browser | "Build like site X" |
| Figma MCP | Input | Figma account + MCP | Figma designs as source |
| Drawbridge | Feedback | Chrome extension | Designer annotations on preview |
| LibreUIUX | Scale | Claude Code skills | Complex multi-component builds |
| Frontend Design Toolkit | Scale | Various MCPs | Full project setup |
| claude-code-frontend-dev | Visual QA | Playwright | Post-APPROVED visual verification |
