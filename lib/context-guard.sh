#!/bin/bash
# PDL context guard — estimates context utilization and recommends degradation.
#
# Claude Code doesn't expose real context size to hooks, so this script uses
# .pdl/ artifact size as a proxy (larger artifacts = more context consumed).
#
# Usage:
#   bash lib/context-guard.sh --round 3 --pdl-dir .pdl
#
# Outputs one of: NORMAL | WARN | DEGRADE | SWITCH_MODEL | PAUSED
# Exit codes:
#   0  NORMAL / WARN / DEGRADE / SWITCH_MODEL — continue (with guidance)
#   1  PAUSED — save checkpoint and exit

PDL_DIR=".pdl"
ROUND=1

while [ $# -gt 0 ]; do
  case "$1" in
    --round)   ROUND="$2"; shift 2 ;;
    --pdl-dir) PDL_DIR="$2"; shift 2 ;;
    *) shift ;;
  esac
done

# Artifact-based proxy: each round accumulates ~2–5 MB
PDL_MB=0
if [ -d "$PDL_DIR" ]; then
  PDL_MB=$(du -sm "$PDL_DIR" 2>/dev/null | awk '{print $1}')
fi

# Simple linear proxy: 5 MB ≈ 75% context for a standard session window
# Adjust FULL_MB to match your typical session size if needed.
FULL_MB=35
USED_PCT=$(python3 -c "print(round(min($PDL_MB / $FULL_MB * 100, 99)))" 2>/dev/null || echo "0")

LEVEL="NORMAL"
ADVICE=""

if   [ "$USED_PCT" -ge 95 ]; then
  LEVEL="PAUSED"
  ADVICE="Save checkpoint to $PDL_DIR/checkpoint.json and exit."
elif [ "$USED_PCT" -ge 85 ]; then
  LEVEL="SWITCH_MODEL"
  ADVICE="Use fast model for ALL steps this round. Gap max 2 lines."
elif [ "$USED_PCT" -ge 75 ]; then
  LEVEL="DEGRADE"
  ADVICE="Skip scrape_reference (use cache). Skip full DESIGN.md read."
elif [ "$USED_PCT" -ge 60 ]; then
  LEVEL="WARN"
  ADVICE="Skip mobile render if responsive > 8.5."
fi

echo "PDL context-guard: round=$ROUND artifact_mb=${PDL_MB} proxy_used=${USED_PCT}% level=$LEVEL"
[ -n "$ADVICE" ] && echo "  => $ADVICE"

if [ "$LEVEL" = "PAUSED" ]; then
  # Write a minimal checkpoint so the user can resume.
  TS=$(date -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date +"%Y-%m-%dT%H:%M:%SZ")
  cat > "$PDL_DIR/checkpoint.json" <<EOF
{"ts":"$TS","round":$ROUND,"reason":"context_${USED_PCT}pct","artifact_mb":$PDL_MB}
EOF
  echo "  Checkpoint saved: $PDL_DIR/checkpoint.json"
  exit 1
fi

exit 0
