# DESIGN — Hero cinematic, B2B SaaS

## Colors
- `--bg`: #0A0F1C (deep navy)
- `--bg-elevated`: #111827
- `--fg`: #E6E8EF
- `--fg-muted`: #8892A6
- `--accent`: #D4A857 (warm gold)
- `--accent-hover`: #E3BC6E
- `--border`: #1F2937
- `--danger`: #E05252

## Typography
- Display: "Canela" (or system serif fallback), 700, scale 1.333
- Body: "Inter", 400/500/600, line-height 1.6
- Mono: "JetBrains Mono", 400
- H1: 72px / 1.05
- H2: 48px / 1.15
- Body: 18px / 1.6

## Components
- Hero (full viewport, 90vh min)
- Primary CTA + secondary link
- Trust bar (6 logos, desaturated)
- Subtle parallax background

## Layout
- 12-column grid, max-width 1280
- Section padding: 120px top, 96px bottom (desktop)
- 8pt spacing scale

## Motion
- Headline fade-up on load (600ms, ease-out)
- Background parallax (0.3x scroll)
- CTA hover: lift 2px + accent glow
- Respects `prefers-reduced-motion`

## Depth
- Elevated surface: 0 1px 3px rgba(0,0,0,0.5)
- Hover card: 0 8px 24px rgba(0,0,0,0.6)

## Brand voice
Confident, understated, numbers-first. No exclamation marks.

## Responsive
320 / 375 / 414 / 768 / 1024 / 1280 / 1440 / 1920 — single column below 768,
2-up trust bar below 1024, full choreography ≥ 1280.

## Accessibility
- Contrast AA+ on all text.
- Focus rings gold, 2px offset.
- Keyboard flow: skip-link → headline → primary CTA → secondary → trust bar.
