# /picasso — Creative Frontend, WebDesign & CRO Orchestrator

## Concept

PICASSO = standalone orchestrator pentru **frontend premium, UX/UI, CRO, 3D, animații, tracking și experiențe web de nivel award-winning**. Combină: designer vizual + creative developer + conversion architect + platform architect.

**Auto-trigger** pe: `design / layout / animation / 3D / webgl / shader / ux / ui / landing / hero / scroll / motion / visual / brand / aesthetic / interactive / imersiv / cro / conversion / funnel / tracking / wireframe / microcopy / platform / webflow / wordpress / headless`

---

## Folosire

```
/picasso <task>
/picasso --mode audit <url>       # Audit vizual + UX + CRO + Performance
/picasso --mode 3d                # Focus WebGL/Three.js/R3F/WebGPU
/picasso --mode animation         # Focus animații (GSAP/Motion/Rive/Theatre.js)
/picasso --mode system            # Design system complet + DESIGN.md
/picasso --mode landing           # Landing page premium cu CRO
/picasso --mode wow               # Maxim visual impact, Awwwards-worthy
/picasso --mode cro               # Conversie, funnel, microcopy, A/B
/picasso --mode spec              # Spec-first: DESIGN.md → cod
/picasso --mode tracking          # GA4 + GTM + Meta Pixel/CAPI setup
/picasso --mode lighthouse        # Loop automat Lighthouse 100/100/100
/picasso --mode wireframe         # Wireframe detaliat text → structură
/picasso --design-loop <task>     # PDL: bidirectional loop cu claude.ai/design
/picasso --design-loop --gate 9.5 --rounds 10 <task>   # Landing critical / Awwwards
/picasso --design-loop --gate 8.5 --rounds 4 <task>    # Prototip rapid
/picasso --design-loop --ref <url> <task>              # Cu referință vizuală
/picasso --design-loop --fallback-manual <task>        # User tweaks finale
/picasso --design-solo <task>         # 1-shot: Claude Design → implementation, fără loop
/picasso --design-critique <task>     # Claude Design auditează implementation existentă
/picasso --design-reference <url>     # Reverse-engineering tokens dintr-un site real
/picasso --design-iterate <task>      # Polish post-APPROVED (single refine pass)
/picasso --scope simple|medium|complex|mega <task>  # Preset auto pt gate + rounds
/picasso --fast <task>                # Max viteză: prompts comprimate, fast scoring, 3r max, 800px
/picasso --budget <cents> <task>      # Limitează costul estimat total (ex: --budget 30)
/picasso --budget <tier>          # standard | premium | elite (default: premium)
/picasso --ref <url>              # Analizează referință și recomandă stack
/picasso --platform <tip>         # next | astro | remix | wordpress | webflow | headless
```

### Design modes (bridge cu claude.ai/design)

| Mode | Când îl folosești | Output |
|---|---|---|
| `--design-loop` | Default. Design bidirecțional până la gate (9.0). | Code + APPROVED.md + rounds artifacts. |
| `--design-solo` | Ai deja un brief clar, vrei 1 pasaj Claude Design → cod, fără iterații. | Code dintr-un singur round. |
| `--design-critique` | Ai implementare existentă, vrei Claude Design să o auditeze. | Gap report + sugestii, fără modificări automate. |
| `--design-reference <url>` | Inspirație dintr-un site real — reverse-engineering tokens înainte de brief. | DESIGN.md pre-populat + paletă + tipografie. |
| `--design-iterate` | După APPROVED, vrei un pas de polish (micro-rafinări). | Patch incremental, gate +0.3. |

### Scope presets (complexity-based routing)

| `--scope` | Gate | Rounds | Tipic |
|---|---:|---:|---|
| `simple` | 8.0 | 3 | 1 component (buton, card) |
| `medium` | 8.5 | 5 | 1 secțiune (hero, pricing) |
| `complex` | 9.0 | 7 | Landing full + `--fallback-manual` ON |
| `mega` | 9.0 | 10 | Site multi-pagină (loop per pagină, coordonare externă) |

Presetele pot fi suprascrise cu `--gate` / `--rounds` explicite.

---

## FAZA 0: BRIEF & CONTEXT

### Mini-template (copy-paste la client)
```
Link (dacă există):
Obiectiv principal:
Public țintă:
Sursă trafic primară:
Platformă actuală:
Screenshot-uri (hero / ofertă / footer):
Lighthouse/PageSpeed mobile:
LCP / CLS / INP:
Analytics disponibile (GA4/GSC/Clarity):
Buget / deadline:
```

### Colectează obligatoriu:
1. **Business goal**: Ce trebuie să facă utilizatorul (cumpăra / completa form / suna)?
2. **Referință vizuală**: Awwwards/Dribbble/Behance SAU descriere stil
3. **Feel**: Ce trebuie să SIMTĂ (premium, playful, tech, luxury, trust)
4. **Constrângeri**: LCP target, browser support, device priority
5. **Platforma**: indiciu pentru FAZA 1.5

### Output FAZA 0
```
PICASSO BRIEF
════════════════════════════════════════
Business goal : [conversie / awareness / retention]
Stil          : [Neumorfic / Glass / Brutalist / Minimal Luxury / etc]
Feel          : [Cinematic / Playful / Corporate Premium / Dark Elite]
LCP Target    : [<800ms / <1.2s / <2s]
Device        : [Mobile-first / Desktop / 50/50]
3D Needed     : [Yes / No / Optional]
Animation     : [Heavy / Medium / Subtle / Micro-only]
CRO Focus     : [High / Medium / Low]
════════════════════════════════════════
```

---

## FAZA 0.5: DESIGN.md SPEC (Spec-First Methodology)

**Principiu**: Feed orice input (PRD / URL / screenshot / brief) → produce `DESIGN.md` → abia apoi cod.

### DESIGN.md — 9 secțiuni standard (Google Stitch format)
```markdown
# DESIGN.md — [Project Name]

## 1. Colors
Primary: #... | Secondary: #... | Accent: #...
Background: #... | Surface: #... | Text: #...
Semantic: success/warning/error/info

## 2. Typography
Heading font: [Geist / Inter / Satoshi / custom]
Body font: [...]
Scale: xs/sm/base/lg/xl/2xl/3xl/4xl/5xl
Weight: 400/500/600/700/800

## 3. Components
Buttons: [primary / secondary / ghost / destructive]
Cards: [radius / shadow / padding]
Inputs: [height / border / focus ring]
Navigation: [sticky / transparent / blur backdrop]

## 4. Layout
Max width: [1200px / 1440px]
Grid: [12col / 8col]
Spacing scale: [4 / 8 / 16 / 24 / 32 / 48 / 64 / 96px]
Breakpoints: 375 / 768 / 1024 / 1280 / 1440 / 1920

## 5. Motion
Duration tokens: fast=150ms / base=300ms / slow=500ms / cinematic=1000ms+
Easing: ease-out (enter) / ease-in (exit) / spring (interactive)
Scroll: [GSAP ScrollTrigger / CSS native / Motion]
Reduce motion: respected always

## 6. Depth / Elevation
Shadow scale: none / sm / md / lg / xl / 2xl
Glassmorphism: blur(12px) saturate(180%) bg-white/10
Z-index scale: 0 / 10 / 20 / 30 / 40 / 50 / modal(100) / overlay(200)

## 7. Brand Guidelines
Logo: [usage rules]
Voice: [ton comunicare]
Don'ts: [ce se evită]

## 8. Responsiveness
Mobile-first → progressive enhancement
Touch targets: min 44×44px
Images: WebP/AVIF + srcset + lazy

## 9. Accessibility
WCAG 2.1 AA minim
Contrast ratio: 4.5:1 text / 3:1 UI
Focus visible: always
Aria labels: pe toate elementele interactive
```

Referințe DESIGN.md consacrate: github.com/VoltAgent/awesome-design-md (68+ exemple: Stripe, Vercel, Apple, Tesla, Linear, Figma etc.)

---

## FAZA 1: PLATFORM SELECTION

```
NEVOIE                          → PLATFORMĂ RECOMANDATĂ
───────────────────────────────────────────────────────
Blog / docs / content           → Astro sau Hugo
Landing simplu + CMS            → Webflow sau Framer
eCommerce standard              → Shopify sau WooCommerce
eCommerce custom / headless     → Next.js + headless commerce backend
App SaaS + marketing site       → Next.js 15 (App Router)
Site creativ / animații grele   → Next.js + R3F + GSAP
Conținut static + performance   → Astro (zero JS by default)
Web standards / edge-first      → Remix 3
CMS flexibil + multilingv       → Next.js + Sanity / Contentful
Budget mic + deadline scurt     → Webflow sau Framer (no-code)
Portfolio personal              → Astro sau Framer
Enterprise / compliance         → Next.js + headless CMS enterprise
```

---

## FAZA 1.5: TECH SELECTION (Visual Stack)

```
STANDARD:
  Next.js/Astro + Lenis + GSAP + Motion + shadcn customizat + react-bits

PREMIUM:
  Next.js + Lenis + GSAP + R3F + Drei + Theatre.js/Rive + custom shaders
  + webdesign-mcp pentru clone/prototype rapid

ELITE:
  Next.js/Remix + WebGPU + Babylon.js/Three.js + GLSL custom + Rive + Theatre.js
  + Howler.js + server-side tracking + edge functions + Cloudinary
```

---

## ARSENAL TEHNOLOGIC

### TIER 1 — Core
Next.js 15 · Astro 5 · Remix 3 · Tailwind v4 · shadcn/ui · react-bits · Lenis · Barba.js · GSAP + ScrollTrigger · Motion (Framer Motion)

### TIER 2 — Premium Visual
Three.js · React Three Fiber · @react-three/drei · @react-three/postprocessing · Spline · GLSL shaders · OGL · Curtains.js · Theatre.js · Rive · tsParticles · Matter.js / Rapier

### TIER 3 — Elite / Bleeding Edge
WebGPU · Babylon.js · @react-three/xr · WebGPU fluids · WGSL compute · Maath · D3/Visx · Troika-three-text · morphSVG · Howler.js / Tone.js · Custom magnetic cursor

### Tools / Design Chain
Figma · Spline · Rive · Blender · After Effects + Lottie · ShaderToy · Storybook · **webdesign-mcp** (local MCP pentru clone/scrape/preview)

---

## FRAMEWORK DE DECIZIE

```
NEVOIE                           → SOLUȚIE
─────────────────────────────────────────────────────
Hero animat cu parallax          → GSAP ScrollTrigger + Lenis
3D produs interactiv             → R3F + Drei + OrbitControls
Shader distortion pe hover       → OGL sau Curtains.js
Animație complexă timeline       → Theatre.js (editor vizual)
Logo / icon animat               → Rive (state machine)
Particule ambient                → tsParticles sau R3F instancing
Page transitions cinematice      → Barba.js + GSAP
Fluid/liquid effect              → WebGPU fluids / Three.js shader
Butoane micro-interacțiuni       → Motion (useAnimate + useSpring)
Text scramble / reveal           → GSAP SplitText
Smooth scroll premium            → Lenis
3D text                          → Troika-three-text
Audio reactiv                    → Howler.js + Web Audio API
AR/VR                            → Babylon.js / @react-three/xr
Clone referință rapidă           → webdesign-mcp /design clone
Content-heavy ultra-rapid        → Astro (zero JS default)
Edge-first / web standards       → Remix 3
```

---

## FAZA 2: COMPONENT ARCHITECTURE

```
components/
├── design-system/
│   ├── DESIGN.md
│   ├── tokens/
│   ├── typography/
│   ├── colors/
│   └── motion/
├── 3d/
│   ├── scenes/
│   ├── shaders/
│   └── models/
├── animations/
│   ├── scroll/
│   ├── page-transitions/
│   └── micro/
├── cro/
│   ├── forms/
│   ├── social-proof/
│   ├── cta/
│   └── funnel/
└── ui/
    └── [shadcn customizat + react-bits]
```

---

## FAZA 3: IMPLEMENT

### Skills activate în ordine (dacă ecosistem de skills disponibil)

**Visual Core:**
ui-ux-pro-max · gsap-scrolltrigger · react-three-fiber · spline-react · motion-react · liquid-glass-design · tailwind-design-system

**CRO + Conversie:**
page-cro · form-cro · onboarding-cro · signup-flow-cro

**Content + Mesaj:**
copywriting · content-strategy · brand-guidelines

**Structură + SEO:**
site-architecture · seo-audit · designing-layouts

**Tracking:**
analytics-tracking

---

## FAZA 3.5: CRO LAYER

### Scorecard
```
UX            : [1-10]  — clarity, flow, friction
CRO           : [1-10]  — CTA, trust, funnel logic
Performance   : [1-10]  — LCP/CLS/INP, Lighthouse
SEO Tehnic    : [1-10]  — meta, schema, vitals
Visual Impact : [1-10]  — first impression, WOW
```

### Priorități (P1–P5)
```
P1 [Impact: High / Efort: Low]  → Quick wins
P2 [Impact: High / Efort: Med]  → Core improvements
P3 [Impact: Med / Efort: Low]   → Easy pickings
P4 [Impact: Med / Efort: High]  → Sprint 2
P5 [Impact: Low / *]            → Backlog
```

### Microcopy Patterns
```
HEADLINES (3 variante): Benefit-led / Problem-led / Social-proof-led
SUBHEADLINES (2 variante): Clarificare benefit / Eliminare obiecție
CTA-uri: Primar (acțiune directă) / Secundar (info) / Urgență (deadline)
TRUST LINES: "Fără card", "Poți anula oricând", "Used by N companies", "GDPR"
OBIECȚII / FAQ (3–5): implementare / contract / fit / preț
```

### Wireframe default (landing)
```
1. HERO — prima impresie + CTA direct
2. PROBLEM / VALUE — pain points → soluție
3. FEATURES / BENEFITS — grid 3 col
4. SOCIAL PROOF — logo-uri + testimoniale
5. CTA FINAL — headline urgency + garanție
6. FOOTER — nav + GDPR
```

---

## FAZA 3.6: TRACKING SETUP

```
GA4:         page_view / scroll_depth / CTA clicks / form events / purchase
GTM:         container publicat + dataLayer push custom
Meta Pixel:  pixel + CAPI server-side
Clarity/Hotjar: session recording + heatmaps
GDPR:        cookie consent banner + Consent Mode v2 + policies
```

---

## FAZA 4: PERFORMANCE AUDIT

### Lighthouse 100 Loop
```
1. Run Lighthouse mobile + desktop
2. Parse failures → prioritizează
3. Apply fixes (imagini, fonts, scripts, caching)
4. Re-run → repeat until 100/100/100/100
```

### Responsive Check: 8 breakpoints
`320 / 375 / 414 / 768 / 1024 / 1280 / 1440 / 1920`

### Performance Checklist
```
CORE WEB VITALS: LCP <800ms · CLS=0 · INP <100ms · TTFB <200ms
IMAGINI: WebP/AVIF · srcset · lazy (nu pe LCP) · preload hero
FONTS: font-display: swap · preload critical · subset
JS: code splitting · tree shaking · third-party async/defer
WEBGL/3D: dispose() cleanup · Draco compression · frame <50ms
CSS ANIM: prefer-reduced-motion · GPU-only (transform + opacity)
CACHING: CDN · Cache-Control · ISR/SSG
```

---

## FAZA 5: WOW + CRO VALIDATION

### WOW Score Matrix (Awwwards)
```
First impression (3s)        25%        9+/10
Scroll storytelling          20%        9+/10
Micro-interacțiuni           15%        8+/10
Performance (Lighthouse)     20%        90+
Originalitate vizuală        10%        8+/10
Accesibilitate (WCAG 2.1)    10%        AA
───────────────────────────────────────────
Total minim pentru SOTD: 88/100
```

### CRO Final Check
```
[ ] Above-the-fold: headline clar + CTA vizibil
[ ] CTA primar ≥ 1 pe fiecare secțiune critică
[ ] Social proof vizibil
[ ] Mobile: CTA sticky
[ ] Formulare: max 3 câmpuri lead gen
[ ] Loading + error states clare
[ ] Trust signals: SSL, GDPR, garanție, reviews
```

### Checklist predare (12 puncte)
```
[ ] Lighthouse 90+ Mobile + Desktop
[ ] Core Web Vitals toate verde
[ ] Responsive 8 breakpoints
[ ] Tracking verificat în GTM Preview + GA4 DebugView
[ ] GDPR: consent + cookie + privacy policies
[ ] SEO: meta + OG + schema JSON-LD + sitemap.xml
[ ] WebGL cleanup verificat
[ ] prefer-reduced-motion respectat
[ ] Accesibilitate: focus visible + aria + contrast AA
[ ] Backup + staging configurat
[ ] Rollback plan documentat
[ ] Smoke test pe CTA principale post-deploy
```

---

## PATTERNS PREMIUM CONSACRATE

```
Pattern 1 — "GSAP + Three.js + Theatre.js + Howler.js + Rive"
Pattern 2 — "Next.js + R3F + Drei + Lenis + GSAP + GLSL custom"
Pattern 3 — "WebGPU + compute shaders + fluid simulation"
Pattern 4 — "OGL + Curtains.js + Barba.js + GSAP"
Pattern 5 — "Babylon.js + WebXR + Cloudinary"
Pattern 6 — "Astro + react-bits + Tailwind v4 + Lenis"
Pattern 7 — "Remix 3 + GSAP + Motion + Cloudflare Workers"
```

---

## WEBDESIGN-MCP INTEGRATION

**Bendix-ai/webdesign-mcp** — MCP server local cu 7 tools:

```
/design clone <url>    → Near-perfect replication din referință
/design enhance <url>  → Păstrează structura, îmbunătățește execuția
/design inspire <url>  → Împrumută stil, conținut original
/design scratch        → De la zero, fără referință

MCP Tools:
  analyze_repo         → Detectează stack (Next/React/Vue, Tailwind, shadcn, tokens)
  scrape_reference     → Playwright: DOM + styling tokens + screenshot din URL
  render_preview       → PNG desktop (1440×900) + mobile (390×844)
  save_design          → Persistă HTML + meta în .webdesign-mcp/runs/<id>/
  refine_design        → Iterează pe design existent
  list_designs / get_design
```

### Instalare webdesign-mcp
```bash
# Prerequisite: bun ≥ 1.1
git clone https://github.com/Bendix-ai/webdesign-mcp
cd webdesign-mcp
./install.sh
claude mcp list | grep webdesign-mcp
```

---

## PICASSO DESIGN LOOP (PDL) — Claude Code ↔ Claude Design

**Concept:** Loop bilateral automat între `/picasso` (Claude Code) și `claude.ai/design` (Claude Design web), orchestrat prin Chrome MCP + webdesign-mcp.

### Prerequisite
- Browser autentificat la `claude.ai`
- Chrome MCP connected (`mcp__Claude_in_Chrome__*`) — install la https://claude.ai/chrome
- webdesign-mcp installed (`claude mcp list | grep webdesign`)
- Cont Pro / Max / Team / Enterprise (Claude Design = research preview)

### Arhitectură

```
Claude Code (/picasso) ←──────────────→ Claude Design (claude.ai/design)
         │                                       │
         ├── Chrome MCP (bridge)                  │
         │   ├── navigate(claude.ai/design)      │
         │   ├── form_input(prompt)              │
         │   ├── get_page_text / screenshot      │
         │   └── upload_image(reference)         │
         │                                       │
         └── webdesign-mcp (validator)            │
             ├── scrape_reference (tokens)       │
             ├── render_preview (PNG)            │
             └── refine_design (iterate)         │
```

### Flow round-by-round

**ROUND 0 — BRIEF**
1. FAZA 0 — collect brief (obiectiv, stil, feel, platform)
2. FAZA 0.5 — generate `DESIGN.md` (9 sections)
3. Build structured prompt for Claude Design

**ROUND N — LOOP CYCLE**

```
1. REQUEST (Chrome MCP)
   navigate → claude.ai/design
   form_input → paste prompt (+ upload_image if --ref)
   wait → Claude Design generates
   screenshot + get_page_text → capture output

2. EXTRACT (webdesign-mcp)
   scrape_reference → DOM + CSS tokens
   parse: colors, typography, spacing, components
   update DESIGN.md

3. IMPLEMENT (/picasso FAZA 3)
   Generate code (Next.js / Astro / Remix + Tailwind + shadcn)
   Write to project

4. COMPARE (webdesign-mcp)
   render_preview → PNG desktop + mobile
   Compare vs Claude Design output
   Score (weighted 0-10)

5. GATE CHECK
   score >= gate (default 9.0) → APPROVED
   score < gate & rounds left   → refine prompt → ROUND N+1
   rounds exhausted             → --fallback-manual → diff + user
```

### Score fidelitate (weighted 0-10)

| Criteriu | Pondere | Verificare |
|---|---|---|
| **Culori** | 25% | Paletă (ΔE < 5 per token) |
| **Tipografie** | 20% | Font family, scale, weight, line-height |
| **Layout/Spacing** | 20% | Grid, margins, padding (±2px) |
| **Componente** | 15% | Butoane, cards, forms structure |
| **Motion** | 10% | Durații, easing, tranziții |
| **Responsive** | 10% | 8 breakpoints |

Gate default: **9.0/10**. Override: `--gate 9.5` / `--gate 8.5`.

### Prompt template pentru Claude Design

```
ROUND {N} — {PROJECT_NAME}

## Goal
{business objective, 1-2 sentences}

## Audience
{target users + context}

## Visual direction
Style: {Neumorphic / Glass / Brutalist / Minimal Luxury / ...}
Feel: {Cinematic / Playful / Corporate / Dark Elite}
Reference: {URL or "see attached image"}

## Constraints
- Platform: Next.js 15 + Tailwind v4 + shadcn/ui
- LCP target: <800ms mobile, WCAG 2.1 AA, prefers-reduced-motion

## Deliverable
{Hero / Pricing / Testimonials / Full landing / etc.}

{IF ROUND > 1:
Gaps to fix from previous round:
- colors: accent was #7C3AED, apply #8B5CF6
- spacing: hero padding-y 64px → 96px
- typography: headline weight 700 → 800}
```

### Fallback matrix

| Situație | Fallback |
|---|---|
| Chrome MCP disconnected | Install `https://claude.ai/chrome` + retry |
| Claude Design rate limit | Pause 60s + retry, then webdesign-mcp standalone |
| Stagnation (score oscilează 2 rounds) | Auto-exit + show diff |
| Score < gate după max rounds | `--fallback-manual` → user tweaks |
| Fără cont Pro+ | Fallback la `/picasso` standard fără loop |

### Agent conductor

PDL este orchestrat de agentul `pdl-conductor` (vezi `agents/pdl-conductor.md`).
Invocare automată via `/picasso --design-loop`.

### Exemple

```bash
# Landing hero premium (critical)
/picasso --design-loop --gate 9.5 --rounds 8 \
  "hero cinematic pentru SaaS B2B, dark elite style"

# Pricing page (business-critical)
/picasso --design-loop --gate 9.0 --rounds 6 \
  "pricing 3-tier cu comparație și FAQ"

# Prototip rapid
/picasso --design-loop --gate 8.0 --rounds 3 \
  "portfolio section concept, minimal luxury"

# Cu referință vizuală
/picasso --design-loop --ref https://linear.app --gate 9.0 \
  "hero similar Linear dar pentru fintech"
```

### Honest disclaimers
- Claude Design = research preview (Pro / Max / Team / Enterprise)
- Fidelitate 100% imposibilă — browser rendering differs (sub-pixel, font hinting)
- Gate 9.5+ poate stagna — 9.0 recomandat default
- Cost tokens: ~3-4× rounds vs `/picasso` standard

---

## RESURSE DE INSPIRAȚIE

```
Design Inspiration:
  awwwards.com/websites/3d/       · awwwards.com/websites/webgl/
  tympanus.net/codrops/           · webgpu.com/showcase/
  dribbble.com                    · behance.net

DESIGN.md Examples (68 branduri):
  github.com/VoltAgent/awesome-design-md
  stitch.withgoogle.com/docs/design-md/

Shader Art:
  shadertoy.com · twigl.app · glslsandbox.com

3D Assets:
  sketchfab.com · poly.pizza · market.pmnd.rs

Motion References:
  rive.app/community · lottiefiles.com · theatrejs.com/examples
```

---

## REGULI NON-NEGOCIABILE

```
#1  Nu compromite performanța pentru vizual. Ambele la 100%.
#2  Mobile-first mereu, chiar și pentru experiențe 3D.
#3  prefer-reduced-motion respectat pe TOATE animațiile.
#4  dispose/cleanup obligatoriu pentru orice WebGL.
#5  Nu lansa pe live fără backup + staging + rollback plan.
#6  UX înainte de UI. Claritate înainte de frumusețe.
#7  Nu supra-arhitectezi proiecte simple. Alege impact/efort optim.
#8  Tracking minim configurat înainte de go-live (GA4 + GTM minim).
#9  GDPR: cookie consent + privacy policy = linie roșie.
#10 Recomandă platforma potrivită, nu cea mai complexă.
```

---

## EXECUTIE RAPIDĂ

```
FAZA 0    BRIEF         — Context, obiectiv, referință, platform hint
FAZA 0.5  DESIGN.md     — Spec-first: colors/typo/motion/components
FAZA 1    PLATFORM      — Next.js / Astro / Remix / Webflow / WordPress
FAZA 1.5  TECH STACK    — Visual tier: Standard/Premium/Elite
FAZA 2    ARCHITECTURE  — Component structure + CRO
FAZA 3    IMPLEMENT     — Skills: visual + CRO + content + SEO + tracking
FAZA 3.5  CRO LAYER     — Scorecard + microcopy + wireframe + P1-P5
FAZA 3.6  TRACKING      — GA4 + GTM + Pixel + GDPR
FAZA 4    PERFORMANCE   — Lighthouse loop + responsive + WebGL cleanup
FAZA 5    VALIDATION    — WOW Score + CRO check + Checklist 12 pct
```

$ARGUMENTS
