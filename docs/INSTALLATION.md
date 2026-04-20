# Installation

## Prerequisites

1. **Claude Code** — https://claude.ai/code
2. **Chrome MCP extension** — https://claude.ai/chrome (required for the Claude Design side of the loop)
3. **webdesign-mcp** — https://github.com/Bendix-ai/webdesign-mcp
4. **A Claude plan with Claude Design access** — Pro, Max, Team, or Enterprise

Without items 2 or 4 the loop cannot operate; `/picasso` still works in classic mode.

## Install the bridge

### macOS / Linux / WSL / Git-Bash

```bash
git clone https://github.com/RazvanGabrielNiculae/picasso-claude-design-claude-code-bridge-loop.git
cd picasso-claude-design-claude-code-bridge-loop
bash scripts/install.sh
```

### Windows (PowerShell)

```powershell
git clone https://github.com/RazvanGabrielNiculae/picasso-claude-design-claude-code-bridge-loop.git
cd picasso-claude-design-claude-code-bridge-loop
pwsh -File scripts\install.ps1
```

## Wire the hook

The installer prints a JSON block. Open `~/.claude/settings.json` and add it to the
`hooks.UserPromptSubmit[].hooks` array:

```json
{
  "command": "bash ~/.claude/hooks/pdl-autodetect.sh",
  "shell": "bash",
  "statusMessage": "PDL handoff detect...",
  "type": "command"
}
```

If `UserPromptSubmit` does not already exist, create it:

```json
"UserPromptSubmit": [
  {
    "hooks": [
      {
        "command": "bash ~/.claude/hooks/pdl-autodetect.sh",
        "shell": "bash",
        "statusMessage": "PDL handoff detect...",
        "type": "command"
      }
    ]
  }
]
```

## Verify

```bash
bash scripts/verify.sh
# or on Windows
pwsh -File scripts\verify.ps1
```

Expected output: `[ok]` for each installed file and the hook registration.

## Install MCP servers (quick reference)

Inside Claude Code:

```bash
# Chrome MCP — install the browser extension from https://claude.ai/chrome
# then make sure it shows "connected" in the MCP panel.

# webdesign-mcp
claude mcp add webdesign-mcp -- npx -y @bendix-ai/webdesign-mcp
```

Check connections in Claude Code's MCP panel; both must be green.

## Uninstall

```bash
bash scripts/uninstall.sh
```

The uninstaller does not touch `settings.json`. Remove the hook block manually.
