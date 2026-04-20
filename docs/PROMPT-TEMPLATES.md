# Prompt Templates

Templates that the conductor feeds into Claude Design. Keep them structured —
short sections, no prose walls.

## Round 0 — initial brief

```
# Brief

Task: <one-line description>
Audience: <who it is for>
Brand: <mood / adjectives>
Reference: <optional URL or description>

# Required sections

- Colors (primary, secondary, accent, neutrals, semantic)
- Typography (display, heading, body, mono; scale; weights; line-heights)
- Components (hero, nav, CTA, cards, footer, ...)
- Layout (grid, sections, spacing scale)
- Motion (choreography, easing, duration)
- Depth (shadows, elevation)
- Brand voice (copy tone)
- Responsive (8 breakpoints: 320, 375, 414, 768, 1024, 1280, 1440, 1920)
- Accessibility (contrast AA+, focus states, keyboard flow)

# Hard constraints

- Dark mode default, light mode optional
- No external font CDNs, prefer system stack or locally-hostable families
- Motion respects prefers-reduced-motion
```

## Round N — refinement

```
# Refinement pass N

Previous score: <score>
Gaps identified:
- <gap 1>
- <gap 2>
- <gap 3>

Changes requested:
- Align color tokens to the palette in DESIGN.md §Colors.
- Rebalance typography scale to the 1.333 ratio.
- Tighten section paddings to the 8pt grid.

Preserve:
- Current component choreography.
- Brand voice in copy.
```

## Edge cases

### When a reference image is provided

```
Reference image: <url>
Extract and mirror:
- Palette (top 8 colors)
- Typography rhythm
- Spacing scale
Do NOT copy components 1:1 — adapt them to the brief above.
```

### When you need strict typography control

```
Typography lock:
- Display: <family>, weight 700, scale 1.333, line-height 1.1
- Body: <family>, weight 400, size 16, line-height 1.6
Do not substitute families even for aesthetic reasons.
```

### When responsiveness is weak

```
Responsive pass:
- Re-render at 320 / 768 / 1440.
- At 320: single column, stacked CTA, condensed nav.
- At 768: 2 columns, expanded nav.
- At 1440: 3 columns, full-bleed hero.
Keep spacing scale consistent across breakpoints.
```
