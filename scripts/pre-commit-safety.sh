#!/bin/bash
# Pre-commit safety scanner for picasso-bridge
# Blochează commit dacă găsește patterns private.
# Install: cp scripts/pre-commit-safety.sh .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit

set -e

FORBIDDEN=(
  # Private orchestrators (NEVER in public repo)
  "medusa"
  "superclaude"
  "ruflo"
  "claude-review"
  "claude-codex"
  "claude-council"
  "claude-council-gateway"
  "asclepius"
  "mega-audit"
  "setupdotclaude"
  "perseus"
  "apollo"
  # Private systems
  "GraphLTM"
  "store_synthesis"
  "search_memory"
  "store_knowledge"
  "AGENT_RULES"
  "AGENT_LEARNINGS"
  "medusa-history"
  "medusa-dashboard"
  "economy-config"
  "ECOSYSTEM-INVENTORY"
  # Personal paths / OS-specific
  "C:/Users/"
  "C:\\\\Users\\\\"
  "/home/"
)

FAILED=0
# Files that are allowed to contain forbidden terms (deny-lists themselves).
EXCLUDE_PATHS=(
  "scripts/pre-commit-safety.sh"
  ".gitignore"
  ".github/PULL_REQUEST_TEMPLATE.md"
  "CONTRIBUTING.md"
)

STAGED=$(git diff --cached --name-only)

if [ -z "$STAGED" ]; then
  exit 0
fi

# Build a diff that excludes allow-listed paths.
EXCLUDE_ARGS=()
for p in "${EXCLUDE_PATHS[@]}"; do
  EXCLUDE_ARGS+=(":(exclude)$p")
done
DIFF=$(git diff --cached -- . "${EXCLUDE_ARGS[@]}")

if [ -z "$DIFF" ]; then
  echo "OK: Pre-commit safety scan: nothing to scan after exclusions."
  exit 0
fi

for term in "${FORBIDDEN[@]}"; do
  MATCHES=$(echo "$DIFF" | grep -iFn "$term" || true)
  if [ -n "$MATCHES" ]; then
    echo "BLOCKED: forbidden term '$term' detected in staged diff:"
    echo "$MATCHES" | head -5
    echo ""
    FAILED=1
  fi
done

if [ $FAILED -eq 1 ]; then
  echo ""
  echo "Remove the flagged lines before committing."
  echo "This repo MUST be independent — no references to private orchestrators or personal info."
  exit 1
fi

echo "OK: Pre-commit safety scan passed."
exit 0
