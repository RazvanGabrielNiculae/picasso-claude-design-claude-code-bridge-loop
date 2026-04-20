# Lifecycle Hooks

The conductor emits events at key points in the loop. Each event is a small shell script that reads JSON from stdin, optionally does something, and exits. All hooks are **optional** — delete them to disable.

## Event sequence

```
install-time:           pdl-autodetect       (UserPromptSubmit in settings.json)

runtime per task:
  pdl-pre-round   ──►  round 1
                        │
                        ▼
  pdl-post-round  ◄──  round 1 scored
                        │
                        ├─ gate met?  ─yes─► pdl-approved  ──► exit APPROVED
                        │
                        ├─ stagnation?  ─► pdl-stagnation  ──► exit STAGNATED | escalate
                        │
                        └─ retry? ─► pdl-pre-round → round 2 → ...

  pdl-failed      ◄──  rounds exhausted / blocked / error
```

## Hook contracts

Each script receives a compact JSON payload on stdin. All hooks use **exit codes** to signal decisions back to the conductor.

### `pdl-autodetect.sh`

Already documented elsewhere. Input: `{prompt: string}`. Output: JSON with `hookSpecificOutput.additionalContext` when a Claude Design handoff phrase is detected. Non-zero additional output only on match.

### `pdl-pre-round.sh`

```json
{ "round": 1, "task": "...", "gate": 9.0, "rounds_max": 6, "mode": "loop" }
```

| Exit | Meaning |
|---:|---|
| 0 | Continue with the round (normal). |
| ≥1 | Abort the round; conductor writes `.pdl/ABORTED.md`. |

Typical use: enforce a per-round time/cost budget, post a "starting round N" ping to a chat channel.

### `pdl-post-round.sh`

```json
{ "round": 3, "score": 8.7, "delta": 0.4, "artifacts_dir": ".pdl/round-3" }
```

| Exit | Meaning |
|---:|---|
| 0 | Continue (evaluate gate / stagnation / next round). |
| 2 | Force APPROVED even if `score < gate` (manual override). |
| 3 | Force abort (writes `.pdl/ABORTED.md`). |

Typical use: live dashboard update, custom early-exit on "good enough".

### `pdl-stagnation.sh`

```json
{ "round": 4, "score": 8.9, "best": 8.9, "rounds_remaining": 2 }
```

| Exit | Meaning |
|---:|---|
| 0 | Accept stagnation; conductor exits `STAGNATED`. |
| 2 | Force APPROVED with current best score. |
| 3 | Escalate — conductor prompts the user for manual tweaks. |

### `pdl-approved.sh`

```json
{ "final_score": 9.12, "rounds": 4, "project_dir": ".", "artifacts_dir": ".pdl" }
```

Exit code is ignored. Use it to auto-commit, open a PR, notify a channel, or archive artifacts.

### `pdl-failed.sh`

```json
{ "reason": "EXHAUSTED|STAGNATED|BLOCKED|ERROR",
  "best_score": 8.4, "best_round": 3, "artifacts_dir": ".pdl" }
```

Exit code is ignored. Use it to notify, archive, or open a fallback ticket.

## Enabling a hook

The installer drops stubs into `~/.claude/hooks/pdl-*.sh`. Edit the stub in place — the conductor invokes the file at `~/.claude/hooks/pdl-<event>.sh` if it exists and is executable. No registration needed beyond the filename.

## Disabling a hook

```bash
chmod -x ~/.claude/hooks/pdl-<event>.sh   # skip without deleting
# or
rm ~/.claude/hooks/pdl-<event>.sh          # fully disable
```

## Debugging

Add a trace line at the top of the stub:

```bash
exec >> /tmp/pdl-hook.log 2>&1
echo "[$(date -Iseconds)] $(basename "$0") $(cat)"
```

Then `tail -f /tmp/pdl-hook.log` while running a round.
