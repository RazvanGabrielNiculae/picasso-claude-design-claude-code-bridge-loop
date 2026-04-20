# Changelog

All notable changes to the Picasso bridge loop are documented here.
Format: [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased] — v0.2.0

### Added

#### Design source flags (`--from-site`, `--from-figma`)
- `--from-site <url>` — extract DESIGN.md tokens from any live site using the
  [bergside/design-md-chrome](https://github.com/bergside/design-md-chrome) pattern
  via `webdesign-mcp scrape_reference`. Seeds round-0 with real production tokens
  instead of inferred ones. Typically reduces rounds-to-gate by 1-2.
- `--from-figma --figma <file-key>` — use Figma MCP as design source instead of
  Claude Design. Requires `claude plugin install figma@claude-plugins-official`.

#### Feedback integration (`--feedback drawbridge`)
- `--design-loop --feedback drawbridge` — reads `moat-tasks.md` from
  [breschio/drawbridge](https://github.com/breschio/drawbridge) browser annotations
  before each REQUEST step. DOM-anchored annotations merged into round gaps.
  Marked "doing" on ingest, "done" on APPROVED.

#### Multi-page consistency (`--multi-page`, SITE.md)
- `--design-loop --multi-page` — enable SITE.md cross-page contract
  (pattern from [jezweb/claude-skills/design-loop](https://github.com/jezweb/claude-skills)).
  Navigation and footer copied from first APPROVED page, never regenerated.

#### Visual scoring tiers
- Numeric scores now map to tier labels: PASS checkcheck / PASS check / PASS WITH NOTES / ITERATE / FAIL.
  Adopted from hemangjoshi37a/claude-code-frontend-dev scoring system.

#### Expanded fallbacks
- from-site and from-figma are now fallbacks when Chrome MCP or Pro access unavailable.

#### Companion tools documentation
- Added `docs/companion-tools.md`: design-md-chrome, Figma MCP, Drawbridge,
  LibreUIUX-Claude-Code, Frontend Design Toolkit, claude-code-frontend-dev.

### Changed
- `agents/pdl-conductor.md` — extended input schema, added PHASE 1.5, 2.1, 3.0.5,
  visual tier labels in PHASE 3.5, expanded fallback matrix.
- `commands/picasso.md` — 4 new flags in usage block.

---

## [0.1.0] — 2026-04-01

### Added
- Initial release: bidirectional Claude Code <-> Claude Design bridge loop.
- 7-step round protocol (request -> extract -> implement -> render -> score -> gaps -> gate).
- Gate scoring: 6 criteria, weighted 0-10, default gate 9.0.
- 5 modes: loop, solo, critique, reference, iterate.
- 4 Karpathy principles baked into conductor.
- 9 orchestration patterns (token cache, fingerprint dedup, idempotency, backpressure,
  zero-context subagents, stagnation detection, early abort, checkpoint/resume, lazy reads).
- 6 lifecycle hooks: pre-round, post-round, stagnation, approved, failed.
- Scope presets: simple / medium / complex / mega.
- One-liner install + SHA256 integrity check.
- scripts/verify.sh --smoke prerequisite checker.
- CONTRIBUTING.md + pre-commit-safety.sh scanner.
