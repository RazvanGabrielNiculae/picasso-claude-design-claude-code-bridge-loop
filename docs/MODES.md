# Modes

`/picasso` supports five orchestration modes against Claude Design, plus four
scope presets that set sensible gate/rounds defaults.

## Modes

### `--design-loop` (default)

Full bidirectional loop. Runs Round 0 (brief) → Round 1…N (request / extract /
implement / render / score / gate) until `score >= gate` or the round budget
is exhausted.

```bash
/picasso --design-loop cinematic hero, dark elite
/picasso --design-loop --gate 9.5 --rounds 10 awwwards landing
```

### `--design-solo`

One shot: `rounds_max = 1`, no gap/refine step. Useful when you already have a
tight brief and just want Claude Design's first pass turned into code.

```bash
/picasso --design-solo sticky promo banner, warm palette
```

### `--design-critique`

Claude Design audits an **existing** implementation. No code is written —
the conductor extracts design tokens from the running implementation, asks
Claude Design to critique them, and writes `.pdl/CRITIQUE.md` with a gap
report.

```bash
/picasso --design-critique ./src/components/hero
```

### `--design-reference <url>`

Reverse-engineering pass. The conductor navigates Claude Design to a
reference URL (or uploads a reference image), extracts tokens, and seeds
`DESIGN.md` with the extracted palette / typography / spacing. Implementation
is not run — you then call `--design-loop` with the seeded brief.

```bash
/picasso --design-reference https://linear.app
/picasso --design-loop "landing in this visual language"
```

### `--design-iterate`

Polish pass after an earlier `APPROVED.md`. Skips Round 0, loads the last
`DESIGN.md`, runs one refine+score cycle at `gate_effective = gate + 0.3`.
Ideal for micro-improvements (kerning, easing curves, spacing rhythm).

```bash
/picasso --design-iterate tighten motion choreography
```

## Scope presets

`--scope` sets gate + rounds together. Override any individual value with
explicit `--gate` or `--rounds`.

| `--scope` | Gate | Rounds | Fallback-manual | Typical task |
|---|---:|---:|---|---|
| `simple` | 8.0 | 3 | off | 1 component (button, card, input) |
| `medium` | 8.5 | 5 | off | 1 section (hero, pricing, testimonial) |
| `complex` | 9.0 | 7 | **on** | Full landing page with multiple sections |
| `mega` | 9.0 | 10 | **on** | Multi-page site (one loop per page, coordinated) |

```bash
/picasso --scope simple  "pricing toggle"
/picasso --scope complex "full marketing landing"
```

## Combining modes and scope

Modes and scopes compose. A common pattern:

```bash
# Stage 1 — seed from a reference
/picasso --design-reference https://linear.app

# Stage 2 — run the full loop at a high gate
/picasso --design-loop --scope complex "landing in this visual language"

# Stage 3 — one polish pass
/picasso --design-iterate
```

## Why these modes

The loop was the original primitive, but real work has different shapes. Each
additional mode takes a specific stage of the design workflow and skips the
parts of the loop that aren't needed. You pay only for the rounds you
actually need.
