# Architecture

## Components

```
┌─────────────────────────────────────────────────────────────────┐
│  Claude Code                                                    │
│                                                                 │
│   ┌──────────────┐    ┌──────────────────┐   ┌───────────────┐  │
│   │ /picasso     │──► │ pdl-conductor    │──►│ implementation│  │
│   │ command      │    │ agent            │   │ (code edits)  │  │
│   └──────────────┘    └────────┬─────────┘   └───────────────┘  │
│                                │                                 │
│                                ▼                                 │
│                       ┌────────────────┐                         │
│                       │ webdesign-mcp  │  (tokens + render      │
│                       │ (local)        │   + scoring)           │
│                       └────────────────┘                         │
│                                                                  │
│                       ┌────────────────┐                         │
│                       │ Chrome MCP     │──► claude.ai/design     │
│                       └────────────────┘                         │
└─────────────────────────────────────────────────────────────────┘
```

## Responsibilities

| Component | Role |
|---|---|
| `/picasso` | User-facing command. PHASE 0 (research) + PHASE 0.5 (DESIGN.md authoring) + PHASE 3 (implementation). |
| `pdl-conductor` | Bridge conductor. Runs rounds, drives Chrome MCP, calls webdesign-mcp, computes scores, enforces the gate. |
| `pdl-autodetect` hook | Pattern-matches incoming user prompts for handoff signals and injects a suggestion to run the loop. |
| Chrome MCP | Opens `claude.ai/design`, submits prompts, reads the resulting design page. |
| webdesign-mcp | Extracts design tokens, renders implementation previews, exposes scoring primitives. |

## Data flow per round

```
[round N prompt]
       │
       ▼
  Chrome MCP ──► claude.ai/design ──► rendered design output (HTML + PNG)
       │
       ▼
  webdesign-mcp.scrape_reference ──► tokens.json
       │
       ▼
  /picasso PHASE 3 (implementation)
       │
       ▼
  webdesign-mcp.render_preview ──► impl-desktop.png / impl-mobile.png
       │
       ▼
  scoring (ΔE + layout + typography + motion + responsive)
       │
       ▼
  gate check: pass → APPROVED, else build gaps → round N+1
```

## Filesystem layout during a session

```
<project_dir>/
├── DESIGN.md                 # authored in PHASE 0.5, refined across rounds
└── .pdl/                     # bridge runtime state (gitignored)
    ├── round-0/
    ├── round-1/
    ├── ...
    └── APPROVED.md | FAILED.md
```

## Stagnation & exit

- Two consecutive rounds with score delta < 0.2 → `STAGNATED`.
- `rounds_max` reached without hitting the gate → `EXHAUSTED`.
- Any missing prerequisite → `BLOCKED` (with fix instructions).
- Technical failure → `ERROR` (with log at `.pdl/error.log`).
