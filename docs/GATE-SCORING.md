# Gate Scoring

The fidelity gate is a single weighted score in `[0, 10]` that compares Claude Design's output to the local implementation.

## Weights

| Criterion | Weight | What it measures |
|---|---:|---|
| Colors | 25% | Dominant palette match via CIE2000 ΔE |
| Typography | 20% | Font family, scale ratio, weights, line-height |
| Layout & spacing | 20% | Grid structure, margins, paddings (±2px tolerance) |
| Components | 15% | Structural match (hero, nav, cards, footer, etc.) |
| Motion | 10% | Duration, easing, transition choreography |
| Responsive | 10% | Behavior across 8 standard breakpoints |

Final score:

```
score = 0.25·colors + 0.20·typography + 0.20·layout
      + 0.15·components + 0.10·motion + 0.10·responsive
```

## Per-criterion scoring

### Colors (25%)

1. Extract 8 dominant colors from both images.
2. For each design color, find the closest implementation color (ΔE CIE2000).
3. Average the ΔE values.
4. Map to `[0, 10]`: `10 · max(0, 1 − avg_ΔE / 20)`.

A ΔE ≤ 5 per token is generally imperceptible to the eye. Anything > 20 is a
completely different color.

### Typography (20%)

- Font family match (binary + fuzzy fallback on web-safe family).
- Scale ratio match: 1.25 / 1.333 / 1.5 etc. — compared with ±5% tolerance.
- Weight match per role (h1…h6, body, caption).
- Line-height match (±0.05 tolerance).

Each sub-metric contributes equally; final typography score is their mean.

### Layout & spacing (20%)

- Grid columns match (inferred from element positions).
- Section margins / paddings within ±2px.
- Alignment (left / center / right) per major element.

### Components (15%)

Binary presence check for structural elements expected by DESIGN.md (hero, nav, CTA, cards, footer, testimonial, etc.). Each missing block subtracts from the score.

### Motion (10%)

- Duration per transition within ±20%.
- Easing family match (linear / ease / cubic-bezier).
- Choreography — staggered entries preserved.

### Responsive (10%)

Rendered previews at 8 widths (320 / 375 / 414 / 768 / 1024 / 1280 / 1440 / 1920). For each width: does the layout match the intent? Average the pass/fail.

## Choosing a gate

| Use case | Gate |
|---|---:|
| Prototype / internal tool | 8.0 |
| Production feature | 8.5 |
| Customer-facing marketing | 9.0 (default) |
| Brand-critical landing | 9.5 (higher stagnation risk) |

Above 9.5 the loop tends to oscillate on micro-differences. Prefer manual tweaks
at that point (`--fallback-manual`).

## Stagnation detection

If `|score_N − score_{N−2}| < 0.2` across two iterations, the conductor exits
with `STAGNATED` and writes a gap report. This prevents infinite loops on
non-actionable micro-diffs.
