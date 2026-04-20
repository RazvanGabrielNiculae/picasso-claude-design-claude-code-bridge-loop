#!/bin/bash
# PDL lifecycle hook — pre-round
#
# Emits a context budget estimate and blocks the round if the budget is
# already exhausted. Customize the thresholds at the top.
#
# Stdin JSON:
#   { "round": 1, "task": "...", "gate": 9.0, "rounds_max": 6, "mode": "loop" }
#
# Exit codes:
#   0  — continue
#   1  — abort (budget or policy violation)

# ---------- thresholds (edit these) ----------
MAX_PDL_MB=50          # abort if .pdl/ folder exceeds this (MB)
WARN_PDL_MB=20         # warn but continue
MAX_ROUND_EARLY=3      # used in early-abort estimate below
# ---------------------------------------------

INPUT=$(cat)
ROUND=$(echo "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('round',1))" 2>/dev/null || echo "1")
PDL_DIR="${PDL_DIR:-.pdl}"

# --- Artifact size check ---
if [ -d "$PDL_DIR" ]; then
  PDL_SIZE_MB=$(du -sm "$PDL_DIR" 2>/dev/null | awk '{print $1}')
  if [ -n "$PDL_SIZE_MB" ] && [ "$PDL_SIZE_MB" -ge "$MAX_PDL_MB" ]; then
    echo "PDL pre-round: .pdl/ is ${PDL_SIZE_MB}MB — exceeds ${MAX_PDL_MB}MB limit." >&2
    echo "Run 'rm -rf $PDL_DIR/round-*/impl-*.png' to prune large previews." >&2
    exit 1
  fi
  if [ -n "$PDL_SIZE_MB" ] && [ "$PDL_SIZE_MB" -ge "$WARN_PDL_MB" ]; then
    echo "PDL pre-round: .pdl/ is ${PDL_SIZE_MB}MB (warn threshold ${WARN_PDL_MB}MB)." >&2
  fi
fi

# --- Round N hooks for user customization ---
# Add your own logic here:
#   send a "starting round $ROUND" Slack ping, record a timestamp, etc.

exit 0
