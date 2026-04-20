# Bridge Loop — walkthrough

A round-by-round description of what happens when you run `/picasso --design-loop`.

## Trigger

Two ways to start the loop:

1. **Explicit** — you run `/picasso --design-loop <task>`.
2. **Auto-suggested** — the `pdl-autodetect` hook sees a handoff phrase in your prompt (`claude.ai/design`, `Claude Design export`, etc.) and inserts a suggestion that you can accept.

## Round 0 — Brief generation

The conductor calls `/picasso` to produce:

- `DESIGN.md` in the project root with 9 sections (colors, typography, components, layout, motion, depth, brand, responsiveness, accessibility).
- A structured prompt for Claude Design at `.pdl/round-0/prompt.md`.

## Round N — execution

```
1. REQUEST
   Chrome MCP navigates to claude.ai/design and submits the round N prompt.
   If this is not the first round, the prompt includes a "Gaps to fix:" section
   derived from the previous round's gap analysis.

2. CAPTURE
   The rendered design is saved as design-output.png and design-html.txt.

3. EXTRACT
   webdesign-mcp.scrape_reference turns the design page into a token bundle
   (colors, typography, spacing, components). The tokens are merged into
   DESIGN.md.

4. IMPLEMENT
   /picasso PHASE 3 applies the updated DESIGN.md to the codebase.

5. RENDER
   webdesign-mcp.render_preview produces impl-desktop.png and impl-mobile.png.

6. SCORE
   Weighted fidelity score across 6 criteria (see GATE-SCORING.md). Stored in
   score.json.

7. GATE
   - score >= gate                    → APPROVED, write APPROVED.md, exit.
   - round == rounds_max              → EXHAUSTED or prompt for manual tweaks.
   - |score - score_{N-2}| < 0.2      → STAGNATED, exit.
   - otherwise                        → derive gaps.md, loop to round N+1.
```

## Per-round artifacts

```
.pdl/round-N/
├── prompt.md              # what we asked Claude Design for
├── design-output.png      # rendered Claude Design output
├── design-html.txt        # page text capture (for token extraction)
├── tokens.json            # extracted tokens
├── impl-desktop.png       # rendered local implementation (desktop)
├── impl-mobile.png        # rendered local implementation (mobile)
├── score.json             # weighted score breakdown
└── gaps.md                # diff narrative used to drive round N+1
```

## Closing the loop

- **APPROVED** — `.pdl/APPROVED.md` is written with final score, rounds consumed, and links to artifacts. You then commit and ship via your normal workflow.
- **EXHAUSTED / STAGNATED** — `.pdl/FAILED.md` is written with best score, gap analysis, and suggested next steps.

## Flags

```
/picasso --design-loop <task>
  --gate <n>               # fidelity gate, default 9.0
  --rounds <n>             # max rounds, default 6
  --ref <url|path>         # reference image handed to Claude Design
  --fallback-manual        # on exhaustion, prompt user for manual tweaks
  --project-dir <path>     # where implementation code is written
```
