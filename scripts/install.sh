#!/bin/bash
# Picasso Design Loop — Installer (bash, macOS/Linux/WSL/Git-Bash)
#
# Copies commands, agents, and hooks into ~/.claude/. Optionally wires the
# pdl-autodetect hook into settings.json automatically.
#
# Usage:
#   bash scripts/install.sh                 # non-interactive, defaults
#   bash scripts/install.sh --wizard        # interactive wizard
#   bash scripts/install.sh --no-hook       # skip hook auto-wiring
#   bash scripts/install.sh --gate 9.0 --rounds 6

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"

WIZARD=0
AUTO_HOOK=1
GATE_DEFAULT="9.0"
ROUNDS_DEFAULT="6"

while [ $# -gt 0 ]; do
  case "$1" in
    --wizard)   WIZARD=1; shift ;;
    --no-hook)  AUTO_HOOK=0; shift ;;
    --gate)     GATE_DEFAULT="$2"; shift 2 ;;
    --rounds)   ROUNDS_DEFAULT="$2"; shift 2 ;;
    -h|--help)
      grep -E "^#( |$)" "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) echo "unknown arg: $1"; exit 2 ;;
  esac
done

echo "Picasso Design Loop installer"
echo "  repo:   $REPO_ROOT"
echo "  target: $CLAUDE_HOME"
echo ""

if [ ! -d "$CLAUDE_HOME" ]; then
  echo "ERROR: $CLAUDE_HOME not found. Install Claude Code first: https://claude.ai/code"
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "WARN: python3 not found. settings.json auto-patch will be skipped."
  AUTO_HOOK=0
fi

# ---------- Wizard ----------
if [ "$WIZARD" = "1" ]; then
  echo "Interactive wizard. Press Enter to accept the default in [brackets]."
  echo ""

  read -r -p "Default gate score (8.0 / 8.5 / 9.0 / 9.5) [$GATE_DEFAULT]: " ANS
  [ -n "$ANS" ] && GATE_DEFAULT="$ANS"

  read -r -p "Default rounds max (3 / 5 / 6 / 8) [$ROUNDS_DEFAULT]: " ANS
  [ -n "$ANS" ] && ROUNDS_DEFAULT="$ANS"

  read -r -p "Auto-wire pdl-autodetect hook into settings.json? (y/N) " ANS
  case "$ANS" in y|Y|yes) AUTO_HOOK=1 ;; *) AUTO_HOOK=0 ;; esac

  echo ""
  echo "Summary:"
  echo "  gate    = $GATE_DEFAULT"
  echo "  rounds  = $ROUNDS_DEFAULT"
  echo "  auto-hook = $([ $AUTO_HOOK -eq 1 ] && echo yes || echo no)"
  echo ""
  read -r -p "Proceed? (Y/n) " ANS
  case "$ANS" in n|N|no) echo "Aborted."; exit 1 ;; esac
fi

# ---------- File install ----------
mkdir -p "$CLAUDE_HOME/commands" "$CLAUDE_HOME/agents" "$CLAUDE_HOME/hooks"

echo "-> Installing /picasso command"
cp "$REPO_ROOT/commands/picasso.md" "$CLAUDE_HOME/commands/picasso.md"

echo "-> Installing pdl-conductor agent"
cp "$REPO_ROOT/agents/pdl-conductor.md" "$CLAUDE_HOME/agents/pdl-conductor.md"

echo "-> Installing hooks"
for f in "$REPO_ROOT"/hooks/*.sh "$REPO_ROOT"/hooks/*.ps1; do
  [ -e "$f" ] || continue
  cp "$f" "$CLAUDE_HOME/hooks/$(basename "$f")"
  case "$f" in *.sh) chmod +x "$CLAUDE_HOME/hooks/$(basename "$f")" ;; esac
done

# ---------- Config ----------
CONFIG_DIR="$CLAUDE_HOME/pdl"
mkdir -p "$CONFIG_DIR"
cat > "$CONFIG_DIR/config.json" <<EOF
{
  "version": "0.1",
  "gate_default": $GATE_DEFAULT,
  "rounds_default": $ROUNDS_DEFAULT,
  "auto_detect_hook": $([ $AUTO_HOOK -eq 1 ] && echo true || echo false)
}
EOF
echo "-> Wrote $CONFIG_DIR/config.json"

# ---------- Auto-wire settings.json ----------
if [ "$AUTO_HOOK" = "1" ]; then
  SETTINGS="$CLAUDE_HOME/settings.json"
  if [ ! -f "$SETTINGS" ]; then
    echo "-> Creating $SETTINGS"
    echo '{}' > "$SETTINGS"
  fi
  # Backup before patching.
  cp "$SETTINGS" "$SETTINGS.bak.$(date +%s)"
  echo "-> Patching $SETTINGS (backup kept as .bak.<ts>)"

  python3 - "$SETTINGS" <<'PYEOF'
import json, sys
path = sys.argv[1]
with open(path, "r", encoding="utf-8") as fh:
    try:
        cfg = json.load(fh)
    except json.JSONDecodeError:
        cfg = {}

cfg.setdefault("hooks", {})
cfg["hooks"].setdefault("UserPromptSubmit", [])

entry = {
    "command": "bash ~/.claude/hooks/pdl-autodetect.sh",
    "shell": "bash",
    "statusMessage": "PDL handoff detect...",
    "type": "command",
    "_pdl_managed": True
}

# Find an existing UserPromptSubmit group; otherwise create one.
if not cfg["hooks"]["UserPromptSubmit"]:
    cfg["hooks"]["UserPromptSubmit"].append({"hooks": []})

group = cfg["hooks"]["UserPromptSubmit"][0]
group.setdefault("hooks", [])

# Avoid duplicates (look for the pdl-autodetect.sh command).
already = any("pdl-autodetect.sh" in (h.get("command") or "") for h in group["hooks"])
if not already:
    group["hooks"].append(entry)

with open(path, "w", encoding="utf-8") as fh:
    json.dump(cfg, fh, indent=2)
    fh.write("\n")

print("   settings.json updated: hook registered" if not already else "   settings.json already had the hook — no change")
PYEOF
fi

echo ""
echo "Installed. Run 'bash scripts/verify.sh' to confirm."
