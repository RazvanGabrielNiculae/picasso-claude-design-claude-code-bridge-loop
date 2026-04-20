#!/bin/bash
# Picasso Design Loop — one-liner bootstrap
#
# Usage:
#   curl -fsSL https://cdn.jsdelivr.net/gh/RazvanGabrielNiculae/picasso-claude-design-claude-code-bridge-loop@main/scripts/install-oneliner.sh | bash
#
# With flags:
#   curl -fsSL ...install-oneliner.sh | bash -s -- --wizard
#   curl -fsSL ...install-oneliner.sh | bash -s -- --ref <branch-or-tag>

set -e

REPO="RazvanGabrielNiculae/picasso-claude-design-claude-code-bridge-loop"
REF="main"
WIZARD=""
EXTRA_ARGS=()

while [ $# -gt 0 ]; do
  case "$1" in
    --ref)     REF="$2"; shift 2 ;;
    --wizard)  WIZARD="--wizard"; shift ;;
    *)         EXTRA_ARGS+=("$1"); shift ;;
  esac
done

CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
STAGE_DIR="$(mktemp -d -t picasso-bridge-XXXXXX)"
trap 'rm -rf "$STAGE_DIR"' EXIT

echo "Picasso Design Loop bootstrap"
echo "  repo:   $REPO"
echo "  ref:    $REF"
echo "  stage:  $STAGE_DIR"
echo "  target: $CLAUDE_HOME"
echo ""

if ! command -v git >/dev/null 2>&1; then
  echo "ERROR: git is required. Install git and retry."
  exit 1
fi

if [ ! -d "$CLAUDE_HOME" ]; then
  echo "ERROR: $CLAUDE_HOME not found. Install Claude Code first: https://claude.ai/code"
  exit 1
fi

echo "-> Cloning $REPO@$REF"
git clone --depth 1 --branch "$REF" "https://github.com/$REPO.git" "$STAGE_DIR/repo" >/dev/null 2>&1 \
  || { echo "ERROR: clone failed"; exit 1; }

echo "-> Running installer"
cd "$STAGE_DIR/repo"
bash scripts/install.sh $WIZARD "${EXTRA_ARGS[@]}"

echo ""
echo "Done. Run 'bash scripts/verify.sh' from a clone of the repo to re-check installation."
