# Picasso Design Loop — Verify installation (PowerShell)

$ClaudeHome = if ($env:CLAUDE_HOME) { $env:CLAUDE_HOME } else { Join-Path $HOME ".claude" }
$Fail = 0

function Check($label, $path) {
    if (Test-Path $path) {
        Write-Host "  [ok]   $label"
    } else {
        Write-Host "  [miss] $label  ($path)"
        $script:Fail = 1
    }
}

Write-Host "Picasso Design Loop -- verification"
Write-Host ""
Write-Host "Files:"
Check "/picasso command"      (Join-Path $ClaudeHome "commands/picasso.md")
Check "pdl-conductor agent"   (Join-Path $ClaudeHome "agents/pdl-conductor.md")
Check "pdl-autodetect hook"   (Join-Path $ClaudeHome "hooks/pdl-autodetect.sh")

Write-Host ""
Write-Host "Hook wiring:"
$SettingsPath = Join-Path $ClaudeHome "settings.json"
if ((Test-Path $SettingsPath) -and (Select-String -Path $SettingsPath -Pattern "pdl-autodetect.sh" -Quiet)) {
    Write-Host "  [ok]   hook registered in settings.json"
} else {
    Write-Host "  [warn] hook not found in settings.json -- add it manually (see scripts/install.ps1)"
}

Write-Host ""
Write-Host "MCP prerequisites (informational):"
Write-Host "  - Chrome MCP:     https://claude.ai/chrome"
Write-Host "  - webdesign-mcp:  https://github.com/Bendix-ai/webdesign-mcp"
Write-Host ""

if ($Fail -eq 0) { Write-Host "Verification passed."; exit 0 }
else              { Write-Host "Verification failed -- re-run scripts/install.ps1"; exit 1 }
