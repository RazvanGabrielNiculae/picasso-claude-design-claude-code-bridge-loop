# Picasso Design Loop — Installer (PowerShell, Windows)
# Copies commands, agents, and hooks into $HOME\.claude\ and prints the hook
# block to add into settings.json.
#
# Usage: pwsh -File scripts/install.ps1

$ErrorActionPreference = "Stop"

$RepoRoot   = Resolve-Path (Join-Path $PSScriptRoot "..")
$ClaudeHome = if ($env:CLAUDE_HOME) { $env:CLAUDE_HOME } else { Join-Path $HOME ".claude" }

Write-Host "Picasso Design Loop installer"
Write-Host "  repo:   $RepoRoot"
Write-Host "  target: $ClaudeHome"
Write-Host ""

if (-not (Test-Path $ClaudeHome)) {
    Write-Error "$ClaudeHome not found. Install Claude Code first."
    exit 1
}

New-Item -ItemType Directory -Force -Path (Join-Path $ClaudeHome "commands") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $ClaudeHome "agents")   | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $ClaudeHome "hooks")    | Out-Null

Write-Host "-> Installing /picasso command"
Copy-Item (Join-Path $RepoRoot "commands/picasso.md") (Join-Path $ClaudeHome "commands/picasso.md") -Force

Write-Host "-> Installing pdl-conductor agent"
Copy-Item (Join-Path $RepoRoot "agents/pdl-conductor.md") (Join-Path $ClaudeHome "agents/pdl-conductor.md") -Force

Write-Host "-> Installing pdl-autodetect hook (sh + ps1)"
Copy-Item (Join-Path $RepoRoot "hooks/pdl-autodetect.sh")  (Join-Path $ClaudeHome "hooks/pdl-autodetect.sh")  -Force
Copy-Item (Join-Path $RepoRoot "hooks/pdl-autodetect.ps1") (Join-Path $ClaudeHome "hooks/pdl-autodetect.ps1") -Force

Write-Host ""
Write-Host "Installed. To activate the hook, add this block to"
Write-Host "$ClaudeHome\settings.json under hooks.UserPromptSubmit[].hooks:"
Write-Host ""
Write-Host '{'
Write-Host '  "command": "bash ~/.claude/hooks/pdl-autodetect.sh",'
Write-Host '  "shell": "bash",'
Write-Host '  "statusMessage": "PDL handoff detect...",'
Write-Host '  "type": "command"'
Write-Host '}'
Write-Host ""
Write-Host "Then run: pwsh -File scripts/verify.ps1"
