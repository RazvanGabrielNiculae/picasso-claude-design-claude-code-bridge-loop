#!/bin/bash
# PDL Auto-Detect Hook
# Detects signals in a user prompt that indicate a handoff from Claude Design
# (claude.ai/design) and injects context suggesting /picasso --design-loop.
#
# Invoked on UserPromptSubmit. Emits JSON with additionalContext on match.

INPUT=$(cat)

PROMPT=$(echo "$INPUT" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('prompt',''))" 2>/dev/null)

if [ -z "$PROMPT" ]; then
  exit 0
fi

PATTERNS=(
  "claude.ai/design"
  "claude design handoff"
  "send to local coding agent"
  "handoff from claude design"
  "design spec from claude"
  "Claude Design export"
)

MATCHED=""
for p in "${PATTERNS[@]}"; do
  if echo "$PROMPT" | grep -iqF "$p"; then
    MATCHED="$p"
    break
  fi
done

if [ -z "$MATCHED" ]; then
  exit 0
fi

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "PDL AUTO-DETECT: handoff pattern from Claude Design detected ('$MATCHED'). Recommendation: start /picasso --design-loop for the bidirectional Claude Code <-> Claude Design bridge with gate 9.0 and automated fidelity scoring. See docs/BRIDGE-LOOP.md."
  }
}
EOF
