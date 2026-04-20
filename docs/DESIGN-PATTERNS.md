# Design Patterns

The Picasso Design Loop is built on nine orchestration patterns. Each pattern
addresses a specific inefficiency in a naive "loop and hope" approach.

---

## 1 — Structured prompt, not prose

**Problem:** prose prompts to Claude Design are verbose and produce inconsistent
token counts. A 500-word brief does not produce a better design than a 50-token
structured brief.

**Solution:** `lib/prompt-builder.sh` generates key: value formatted inputs.
Round-0 is ~250 tokens. Round-N is ~100 tokens. Zero prose.

**Effect:** 5× prompt compression vs unstructured input.

**Reference:** prompt compression / structured output research.

---

## 2 — Content-hash cache

**Problem:** `scrape_reference` is called every round even when Claude Design
produced essentially the same output as the previous round.

**Solution:** after each extraction, hash the first 4 KB of the design HTML.
If the hash matches the previous round, skip extraction entirely and reuse
`tokens.json`.

**Effect:** saves 1 MCP call per round on average; eliminates redundant DESIGN.md
writes.

---

## 3 — Fingerprint deduplication

**Problem:** Claude Design sometimes produces visually identical output on
successive rounds (different HTML, same rendered result). The conductor would
score it, find the same gap, and loop indefinitely.

**Solution:** after scoring, hash `tokens.json + score.json[:100]`. If the
fingerprint already exists in `.pdl/fingerprints.txt`, the loop cannot improve
— exit `STAGNATED` immediately.

**Effect:** eliminates wasted rounds on semantically identical outputs.

---

## 4 — Lazy section reads

**Problem:** DESIGN.md has 9 sections (~450 tokens full). If only typography
changed in a round, reading all 9 sections is wasteful.

**Solution:** the conductor tracks which sections changed per round. Only
those sections are read before delegating implementation.

**Effect:** from ~450 tok to ~50 tok per round after round 1.

---

## 5 — Model routing per step

**Problem:** using a large reasoning model for arithmetic (color ΔE, layout
pixel comparison) wastes money. Using a fast model for gap synthesis produces
shallow analysis.

**Solution:** route each step to the appropriate model size:

| Step | Model size |
|---|---|
| Hash check, score computation | Fast (small) |
| Gap synthesis, DESIGN.md merge | Standard |
| Stagnation recovery analysis | Large (rare) |

**Effect:** ~40% cost reduction per round with no quality loss on scoring.

---

## 6 — Adaptive rendering

**Problem:** rendering mobile preview every round costs one MCP call regardless
of whether the mobile layout actually changed.

**Solution:** skip mobile render if the previous round's responsive score is ≥ 8.0
(the layout is stable; only re-render when it drops below threshold).

**Effect:** saves 1 `render_preview` call in most rounds after round 2.

---

## 7 — Zero-context subagent dispatch

**Problem:** delegating implementation to `/picasso` PHASE 3 as a continuation
of the same session means the implementation agent inherits the full conductor
context — thousands of tokens of loop history that the implementer doesn't need.

**Solution:** dispatch as a zero-context subagent: pass only the changed
DESIGN.md sections + project dir. The subagent starts fresh.

**Effect:** subagent receives ~200 tok vs ~2,000 tok. At 6 rounds: −10k tok.

---

## 8 — Idempotency before every write

**Problem:** implementation passes sometimes re-write files that are already
correct (no actual change). This creates empty git diff noise and wastes tokens.

**Solution:** compute `sha256` of the current file and the proposed content
before writing. Skip the write if hashes match.

**Effect:** clean diffs; prevents spurious re-writes in stable sections.

---

## 9 — Context backpressure

**Problem:** long loops can approach the session context limit. Without
guardrails, the conductor either crashes or produces degraded output silently.

**Solution:** `lib/context-guard.sh` uses `.pdl/` artifact size as a proxy for
context utilization and enforces graduated degradation:

| Proxy level | Action |
|---|---|
| < 60% | All steps enabled |
| 60–75% | Skip optional renders |
| 75–85% | Cache-only extraction; lazy reads |
| 85–95% | Fast model for all steps |
| > 95% | Save checkpoint → exit `PAUSED` |

A checkpoint at `.pdl/checkpoint.json` lets the user resume from the last
completed round in a new session.

**Effect:** graceful degradation instead of silent failure; resumable sessions.

---

## Pattern interaction

```
Round N
  │
  ├── [2] hash cache?      yes → skip scrape  (saves 1 MCP call)
  │                        no  → scrape + hash
  │
  ├── [4] lazy sections?   only changed → small read
  │
  ├── [5] model route      scoring → fast; synthesis → standard
  │
  ├── [6] mobile?          responsive >= 8.0 → skip render
  │
  ├── [7] zero-context     implementation subagent starts clean
  │
  ├── [8] idempotency      write only if file changed
  │
  ├── [3] fingerprint?     match → STAGNATED (exit early)
  │
  └── [9] context guard    > 95% → checkpoint → PAUSED
```

Pattern [1] (structured prompt) applies only at Round-0 and Round-N prompt
generation. All others apply inside the round execution.

---

## Philosophical foundation

The nine patterns above are the mechanisms. They are grounded in four principles
derived from Andrej Karpathy's observations on LLM coding pitfalls:

### Think before coding

Models produce better output when they surface assumptions before acting, rather
than silently adopting an interpretation. In Picasso this appears as:
- **Assumption surface** in PHASE 2 — before the first Claude Design call, list
  inferred tokens (colors, type, components) and allow the user to correct them.
- **EARLY_ABORT with explanation** — when trajectory is failing, state the reason
  explicitly instead of running to exhaustion.

### Simplicity first

The implementation subagent receives the minimum context and a strict constraint:
edit only what the gap requires. This prevents the natural tendency to clean up
adjacent code, add speculative features, or over-engineer a one-round fix.

### Surgical changes

Pattern [7] (zero-context subagent) and Pattern [8] (idempotency) are both
surgical-change enforcements. Zero-context means the subagent has no history to
act on beyond the delta. Idempotency means unchanged files are never touched.

### Goal-declared targets

Pattern [1] encodes this: Round-N prompts use `Targets: X → Y` format, not
imperative `Fix: do X`. A declared target state lets Claude Design iterate toward
a verifiable endpoint. The gate score is the objective function that confirms
the target was reached — not the conductor's subjective judgment.
