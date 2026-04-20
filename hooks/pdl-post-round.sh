#!/bin/bash
# PDL lifecycle hook — post-round
#
# Checks token-hash cache to emit a CACHE_HIT/MISS signal, and provides a
# hook point for dashboards, custom early-exit logic, and telemetry.
#
# Stdin JSON:
#   { "round": 3, "score": 8.7, "delta": 0.4, "artifacts_dir": ".pdl/round-3" }
#
# Exit codes:
#   0  — continue (evaluate gate / stagnation / next round)
#   2  — force APPROVED (manual override)
#   3  — force abort

INPUT=$(cat)
ROUND=$(echo "$INPUT"       | python3 -c "import json,sys; print(json.load(sys.stdin).get('round',1))" 2>/dev/null || echo "1")
SCORE=$(echo "$INPUT"       | python3 -c "import json,sys; print(json.load(sys.stdin).get('score',0))" 2>/dev/null || echo "0")
ARTIFACTS=$(echo "$INPUT"   | python3 -c "import json,sys; print(json.load(sys.stdin).get('artifacts_dir','.pdl/round-1'))" 2>/dev/null || echo ".pdl/round-1")

# --- Token cache reporting ---
HASH_NOW="$ARTIFACTS/tokens.hash"
PREV_ROUND=$((ROUND - 1))
HASH_PREV=".pdl/round-$PREV_ROUND/tokens.hash"

if [ "$ROUND" -gt 1 ] && [ -f "$HASH_NOW" ] && [ -f "$HASH_PREV" ]; then
  NOW=$(cat "$HASH_NOW")
  PREV=$(cat "$HASH_PREV")
  if [ "$NOW" = "$PREV" ]; then
    echo "PDL cache: round $ROUND tokens unchanged (cache hit — scrape skipped)" >&2
  else
    echo "PDL cache: round $ROUND tokens changed (cache miss — scrape ran)" >&2
  fi
fi

# --- Economy log (append to ~/.claude/pdl/economy.jsonl) ---
if command -v python3 >/dev/null 2>&1; then
  ECON_DIR="${CLAUDE_HOME:-$HOME/.claude}/pdl"
  mkdir -p "$ECON_DIR"
  TS=$(date -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date -u +"%Y-%m-%dT%H:%M:%SZ")
  python3 -c "
import json, os
entry = {'ts':'$TS','round':$ROUND,'score':$SCORE,'artifacts':'$ARTIFACTS'}
with open('$ECON_DIR/economy.jsonl', 'a') as f:
    f.write(json.dumps(entry) + '\n')
" 2>/dev/null || true
fi

# --- Add custom logic here ---
# e.g. push score to a live dashboard, trigger a Slack message, etc.

exit 0
