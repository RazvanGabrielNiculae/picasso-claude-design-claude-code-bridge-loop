#!/bin/bash
# PDL prompt builder — generates compressed, structured prompts for Claude Design.
#
# Round 0: full brief (~250 tokens)
# Round N: delta-only with top-3 gaps (~100 tokens)
#
# Usage:
#   bash lib/prompt-builder.sh --round 0 --task "hero, dark elite" --design DESIGN.md
#   bash lib/prompt-builder.sh --round 2 --gaps .pdl/round-1/gaps.md

set -e

ROUND=0
TASK=""
DESIGN_MD=""
GAPS_FILE=""

while [ $# -gt 0 ]; do
  case "$1" in
    --round)    ROUND="$2"; shift 2 ;;
    --task)     TASK="$2"; shift 2 ;;
    --design)   DESIGN_MD="$2"; shift 2 ;;
    --gaps)     GAPS_FILE="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ "$ROUND" = "0" ]; then
  # ---- Round 0: structured brief ----
  # Extract key tokens from DESIGN.md (colors line, type line, components line).
  COLORS=""
  TYPE=""
  COMPONENTS=""
  MOOD=""

  if [ -f "$DESIGN_MD" ]; then
    COLORS=$(grep -A1 "^## Colors" "$DESIGN_MD" 2>/dev/null | tail -1 | sed 's/^[[:space:]]*//')
    TYPE=$(grep -A1 "^## Typography" "$DESIGN_MD" 2>/dev/null | tail -1 | sed 's/^[[:space:]]*//')
    COMPONENTS=$(grep -A1 "^## Components" "$DESIGN_MD" 2>/dev/null | tail -1 | sed 's/^[[:space:]]*//')
    MOOD=$(grep -A1 "^## Brand" "$DESIGN_MD" 2>/dev/null | tail -1 | sed 's/^[[:space:]]*//')
  fi

  cat <<PROMPT
Task: ${TASK}
Colors: ${COLORS:-derive from task mood}
Type: ${TYPE:-derive from task mood}
Components: ${COMPONENTS:-hero cta footer}
Brand: ${MOOD:-confident, operator-grade}
Constraints: prefers-reduced-motion | AA+ contrast | no external CDN | system-stack fallback
Output: full design spec + visual preview. No prose explanation.
PROMPT

else
  # ---- Round N: compressed delta ----
  GAPS=""
  if [ -f "$GAPS_FILE" ]; then
    # Take max 3 non-empty lines, each trimmed
    GAPS=$(grep -v '^[[:space:]]*$' "$GAPS_FILE" 2>/dev/null | head -3 | paste -sd ' | ')
  fi

  if [ -z "$GAPS" ]; then
    # No gap file — ask for a general refinement
    GAPS="refine overall fidelity to the brief"
  fi

  # Gaps are goal-declared (current → target), not imperative.
  # This lets Claude Design iterate toward an explicit measured target.
  cat <<PROMPT
Targets: ${GAPS}
Keep: established colors, brand voice, overall structure.
Output: updated design preview only. No prose.
PROMPT
fi
