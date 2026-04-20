#!/bin/bash
# PDL budget preflight — estimates total loop cost and checks against limit.
#
# Usage:
#   bash lib/budget-preflight.sh --rounds 6 --gate 9.0
#   bash lib/budget-preflight.sh --rounds 6 --budget 50
#
# Exit codes:
#   0  budget OK — proceed
#   1  BUDGET_CAP_HIT — abort

set -e

ROUNDS=6
GATE=9.0
BUDGET_CENTS=""
BUDGET_FILE="${CLAUDE_HOME:-$HOME/.claude}/pdl/budget.json"

while [ $# -gt 0 ]; do
  case "$1" in
    --rounds)  ROUNDS="$2";      shift 2 ;;
    --gate)    GATE="$2";        shift 2 ;;
    --budget)  BUDGET_CENTS="$2"; shift 2 ;;
    *) shift ;;
  esac
done

# Cost model (per round, mixed fast+standard model):
#   fast scoring:       ~0.08¢ / 1k tokens × 1k  = ~0.08¢
#   standard synthesis: ~0.60¢ / 1k tokens × 1k  = ~0.60¢
#   browser MCP:        ~0 (local, no API cost)
#   render preview:     ~0 (local MCP)
COST_PER_ROUND="0.68"

ESTIMATED=$(python3 -c "print(round($ROUNDS * $COST_PER_ROUND, 2))" 2>/dev/null || echo "$ROUNDS")

echo "PDL budget preflight:"
echo "  rounds_max:      $ROUNDS"
echo "  cost_per_round:  ${COST_PER_ROUND}¢"
echo "  estimated_total: ${ESTIMATED}¢"

# --- Check explicit --budget flag ---
if [ -n "$BUDGET_CENTS" ]; then
  OK=$(python3 -c "print('yes' if $ESTIMATED <= $BUDGET_CENTS else 'no')" 2>/dev/null || echo "yes")
  if [ "$OK" = "no" ]; then
    echo "  BUDGET_CAP_HIT: estimated ${ESTIMATED}¢ > limit ${BUDGET_CENTS}¢"
    echo "  Reduce --rounds or raise --budget"
    exit 1
  fi
  echo "  budget_limit:    ${BUDGET_CENTS}¢  [OK]"
  exit 0
fi

# --- Check ~/.claude/pdl/budget.json ---
if [ -f "$BUDGET_FILE" ] && command -v python3 >/dev/null 2>&1; then
  RESULT=$(python3 - "$BUDGET_FILE" "$ESTIMATED" <<'PYEOF'
import json, sys
path, estimated = sys.argv[1], float(sys.argv[2])
try:
    cfg = json.load(open(path))
    daily_limit  = float(cfg.get("daily_budget_cents", 999))
    daily_spent  = float(cfg.get("daily_spent_cents", 0))
    available    = daily_limit - daily_spent
    if estimated > available:
        print(f"BUDGET_CAP_HIT: estimated {estimated}¢ > available {available:.2f}¢ (limit {daily_limit}¢, spent {daily_spent}¢)")
    else:
        print(f"OK: {daily_spent:.2f}¢ spent today, {available:.2f}¢ available, need {estimated}¢")
except Exception as e:
    print(f"OK: budget file error ({e}), proceeding without cap")
PYEOF
)
  echo "  $RESULT"
  if echo "$RESULT" | grep -q "^BUDGET_CAP_HIT"; then
    exit 1
  fi
fi

exit 0
