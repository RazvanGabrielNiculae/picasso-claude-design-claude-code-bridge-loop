# Changelog

All notable changes to this project will be documented in this file.
Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added
- Model routing table in `pdl-conductor`: fast model for scoring, standard for synthesis, large for stagnation recovery.
- Context backpressure thresholds (4 levels: WARN/DEGRADE/SWITCH_MODEL/PAUSED) via `lib/context-guard.sh`.
- Budget preflight check via `lib/budget-preflight.sh` + `--budget <cents>` flag on `/picasso`.
- `~/.claude/pdl/budget.json` for configurable daily cap.
- Fingerprint deduplication per round (`.pdl/fingerprints.txt`) — early exit on identical Claude Design output.
- Idempotency check before every implementation file write.
- Zero-context subagent dispatch pattern for PHASE 3 delegation.
- `PAUSED` exit code + checkpoint at `.pdl/checkpoint.json` for resumable sessions.
- `BUDGET_CAP_HIT` exit code.
- `docs/DESIGN-PATTERNS.md` — 9 orchestration patterns documented with interaction diagram.
- Token-optimization doc extended with model routing, backpressure, budget preflight, and fingerprint sections.

## [0.1.0] — 2026-04-20

### Added
- `/picasso` slash command — creative front-end orchestrator.
- `/picasso --design-loop` flag — bidirectional Claude Code ↔ Claude Design loop.
- Four additional modes: `--design-solo`, `--design-critique`, `--design-reference <url>`, `--design-iterate`.
- Scope presets: `--scope simple|medium|complex|mega` (sets gate + rounds + fallback-manual).
- `pdl-conductor` agent — manages rounds, scoring, gate enforcement, mode branching.
- `pdl-autodetect` hook — detects Claude Design handoff patterns in prompts.
- Lifecycle hook stubs: `pdl-pre-round`, `pdl-post-round`, `pdl-stagnation`, `pdl-approved`, `pdl-failed`.
- One-liner installer hosted via jsDelivr: `curl … | bash` (with optional `--wizard`).
- Interactive install wizard (`install.sh --wizard`).
- Auto-patching of `~/.claude/settings.json` (timestamped backup kept).
- Installers for bash and PowerShell.
- Verification script with offline `--smoke` mode.
- Uninstaller that cleanly unregisters `_pdl_managed` hook entries.
- Documentation set (architecture, installation, bridge loop, modes, hooks, gate scoring, prompt templates, troubleshooting).
