# Troubleshooting

## `verify.sh` reports `[miss]` for a file

Re-run the installer. If a file is still missing, check filesystem permissions
on `~/.claude/`.

## Hook not firing

Symptom: the auto-detect suggestion never appears when your prompt contains
a handoff phrase.

- Confirm the hook block exists in `~/.claude/settings.json`.
- Check that `bash ~/.claude/hooks/pdl-autodetect.sh` is executable
  (`chmod +x`).
- Run the hook manually:
  ```bash
  echo '{"prompt":"Here is a Claude Design export"}' | bash ~/.claude/hooks/pdl-autodetect.sh
  ```
  You should see a JSON object with `additionalContext`.

## Chrome MCP is not connected

- Install the extension from https://claude.ai/chrome.
- Restart Claude Code after installing.
- Check the MCP panel — the entry must be green.
- If it lists as `read-only tier`: navigate actions are allowed, but typing
  may be blocked depending on the target app tier. For `claude.ai` this
  should be full tier.

## Claude Design is not available

- Claude Design is a research preview restricted to Pro / Max / Team /
  Enterprise plans. If you are on the free tier, the loop will exit with
  `BLOCKED`.
- If you are on a supported plan but `/design` still doesn't load, visit
  https://claude.ai/design directly in the browser first and make sure
  you're logged in.

## `webdesign-mcp` scoring fails

- Confirm the MCP is registered:
  ```bash
  claude mcp list
  ```
  `webdesign-mcp` should be listed.
- Check that Node.js is available in PATH (the MCP runs via `npx`).
- If scoring hangs on large pages, try rendering the preview at a smaller
  viewport first.

## Loop stagnates

- The default gate is 9.0. At 9.5+ the loop often oscillates on micro-diffs.
- Use `--fallback-manual` to hand control back to the user when rounds are
  exhausted.
- Inspect `.pdl/round-N/gaps.md` — if the gaps are non-actionable ("slight
  color shift", "minor kerning"), you are at the perceptual limit and should
  approve manually.

## Rate limits

- The conductor retries up to 3 times with 60s backoff. After that it exits
  with `rate_limit_hit`.
- If you hit the limit repeatedly, lower `--rounds` or batch loops across
  sessions.

## Pre-commit scanner blocks a commit

The scanner (`scripts/pre-commit-safety.sh`) rejects commits that mention
private orchestrator names or personal paths. Remove the flagged lines and
re-commit — do not bypass with `--no-verify`.
