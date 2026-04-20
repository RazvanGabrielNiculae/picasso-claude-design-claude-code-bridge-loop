# Contributing

Thanks for considering a contribution!

## Ground rules

1. **No private data in PRs.** Do not add references to personal paths (e.g. `/home/<name>`, `C:/Users/<name>`), internal orchestrators, private skills, or third-party ecosystem tooling unrelated to this repo. A pre-commit scanner (`scripts/pre-commit-safety.sh`) blocks known private terms; run it locally before pushing.
2. **Independent orchestrator.** This repo is a standalone bridge for Claude Code ↔ Claude Design. PRs that couple it to other private ecosystems will be rejected.
3. **Clear commits.** Use imperative present-tense messages (`add`, `fix`, `refactor`).

## Local setup

```bash
git clone https://github.com/RazvanGabrielNiculae/picasso-claude-design-claude-code-bridge-loop.git
cd picasso-claude-design-claude-code-bridge-loop
bash scripts/install.sh
bash scripts/verify.sh
```

Install the pre-commit hook:

```bash
cp scripts/pre-commit-safety.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

## Testing changes

- **Command changes** (`commands/picasso.md`): test via a fresh `/picasso` invocation in Claude Code.
- **Agent changes** (`agents/pdl-conductor.md`): invoke the agent directly with a Task call.
- **Hook changes** (`hooks/pdl-autodetect.sh`): simulate a prompt and pipe it through the hook script.

## PR checklist

- [ ] `bash scripts/verify.sh` passes.
- [ ] Pre-commit scanner passes on the staged diff.
- [ ] No references to third-party private orchestrators or personal paths.
- [ ] Documentation updated (README + relevant `docs/` file).
- [ ] Changelog entry added under the Unreleased section.
