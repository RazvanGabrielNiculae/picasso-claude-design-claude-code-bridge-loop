#!/bin/bash
# Picasso Design Loop — verification
#
# Modes:
#   bash scripts/verify.sh             # file + hook registration check
#   bash scripts/verify.sh --smoke     # + offline smoke test (no browser, no MCP)

CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
SMOKE=0
FAIL=0

case "$1" in
  --smoke|-s) SMOKE=1 ;;
esac

check() {
  local label="$1"
  local path="$2"
  if [ -e "$path" ]; then
    echo "  [ok]   $label"
  else
    echo "  [miss] $label  ($path)"
    FAIL=1
  fi
}

echo "Picasso Design Loop -- verification"
echo ""
echo "Files:"
check "/picasso command"       "$CLAUDE_HOME/commands/picasso.md"
check "pdl-conductor agent"    "$CLAUDE_HOME/agents/pdl-conductor.md"
check "pdl-autodetect hook"    "$CLAUDE_HOME/hooks/pdl-autodetect.sh"
check "pdl config"             "$CLAUDE_HOME/pdl/config.json"

echo ""
echo "Hook wiring:"
if grep -q "pdl-autodetect.sh" "$CLAUDE_HOME/settings.json" 2>/dev/null; then
  echo "  [ok]   hook registered in settings.json"
else
  echo "  [warn] hook not found in settings.json -- re-run install.sh --wizard"
fi

echo ""
echo "Optional lifecycle hooks:"
for h in pre-round post-round stagnation approved failed; do
  if [ -e "$CLAUDE_HOME/hooks/pdl-$h.sh" ]; then
    echo "  [ok]   pdl-$h.sh"
  else
    echo "  [--]   pdl-$h.sh (optional, not installed)"
  fi
done

echo ""
echo "MCP prerequisites (informational — check inside Claude Code):"
echo "  - Chrome MCP:     https://claude.ai/chrome"
echo "  - webdesign-mcp:  https://github.com/Bendix-ai/webdesign-mcp"

if [ $SMOKE -eq 1 ]; then
  echo ""
  echo "Smoke test (offline, no browser, no MCP):"
  SMOKE_DIR="$(mktemp -d -t pdl-smoke-XXXXXX)"
  trap 'rm -rf "$SMOKE_DIR"' EXIT

  # 1) handoff hook emits additionalContext on a known pattern
  HOOK_OUT=$(echo '{"prompt":"Here is a Claude Design export for review"}' \
    | bash "$CLAUDE_HOME/hooks/pdl-autodetect.sh" 2>/dev/null)
  if echo "$HOOK_OUT" | grep -q "PDL AUTO-DETECT"; then
    echo "  [ok]   autodetect hook fires on known pattern"
  else
    echo "  [fail] autodetect hook did not fire"
    FAIL=1
  fi

  # 2) autodetect hook is a no-op on unrelated prompt
  HOOK_OUT=$(echo '{"prompt":"add a CLI flag"}' \
    | bash "$CLAUDE_HOME/hooks/pdl-autodetect.sh" 2>/dev/null)
  if [ -z "$HOOK_OUT" ]; then
    echo "  [ok]   autodetect hook is silent on unrelated prompt"
  else
    echo "  [fail] autodetect hook fired unexpectedly"
    FAIL=1
  fi

  # 3) config.json parses as JSON
  if python3 -c "import json,sys;json.load(open('$CLAUDE_HOME/pdl/config.json'))" 2>/dev/null; then
    echo "  [ok]   pdl/config.json is valid JSON"
  else
    echo "  [fail] pdl/config.json is not valid JSON"
    FAIL=1
  fi
fi

echo ""
if [ $FAIL -eq 0 ]; then
  echo "Verification passed."
  exit 0
else
  echo "Verification failed."
  exit 1
fi
