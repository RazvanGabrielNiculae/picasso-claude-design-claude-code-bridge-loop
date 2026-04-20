#!/bin/bash
# Picasso Design Loop — Uninstaller
#
# Removes installed files and unregisters the pdl-autodetect hook from
# settings.json (only entries flagged with _pdl_managed: true are removed,
# so user-authored hooks are left intact).

set -e

CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"

echo "Removing Picasso Design Loop files from $CLAUDE_HOME"

rm -f "$CLAUDE_HOME/commands/picasso.md"
rm -f "$CLAUDE_HOME/agents/pdl-conductor.md"
rm -f "$CLAUDE_HOME/hooks/pdl-autodetect.sh"
rm -f "$CLAUDE_HOME/hooks/pdl-autodetect.ps1"
rm -f "$CLAUDE_HOME/hooks/pdl-pre-round.sh"
rm -f "$CLAUDE_HOME/hooks/pdl-post-round.sh"
rm -f "$CLAUDE_HOME/hooks/pdl-stagnation.sh"
rm -f "$CLAUDE_HOME/hooks/pdl-approved.sh"
rm -f "$CLAUDE_HOME/hooks/pdl-failed.sh"
rm -rf "$CLAUDE_HOME/pdl"

SETTINGS="$CLAUDE_HOME/settings.json"
if [ -f "$SETTINGS" ] && command -v python3 >/dev/null 2>&1; then
  cp "$SETTINGS" "$SETTINGS.bak.$(date +%s)"
  echo "-> Removing PDL-managed hook entries from settings.json (backup kept)"
  python3 - "$SETTINGS" <<'PYEOF'
import json, sys
path = sys.argv[1]
with open(path, "r", encoding="utf-8") as fh:
    try:
        cfg = json.load(fh)
    except json.JSONDecodeError:
        print("   settings.json is not valid JSON, skipping")
        sys.exit(0)

groups = cfg.get("hooks", {}).get("UserPromptSubmit", [])
removed = 0
for g in groups:
    before = len(g.get("hooks", []))
    g["hooks"] = [
        h for h in g.get("hooks", [])
        if not (h.get("_pdl_managed") or "pdl-autodetect" in (h.get("command") or ""))
    ]
    removed += before - len(g["hooks"])

# Prune empty groups.
cfg.setdefault("hooks", {})["UserPromptSubmit"] = [g for g in groups if g.get("hooks")]

with open(path, "w", encoding="utf-8") as fh:
    json.dump(cfg, fh, indent=2)
    fh.write("\n")
print(f"   removed {removed} hook entry/entries")
PYEOF
fi

echo ""
echo "Uninstall complete."
