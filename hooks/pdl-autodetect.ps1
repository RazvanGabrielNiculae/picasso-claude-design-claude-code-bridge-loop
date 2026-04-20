# PDL Auto-Detect Hook (PowerShell port)
# Detects handoff signals from Claude Design in a user prompt and suggests
# /picasso --design-loop via hook additionalContext.

$Input = [Console]::In.ReadToEnd()

try {
    $Parsed = $Input | ConvertFrom-Json
    $Prompt = $Parsed.prompt
} catch {
    exit 0
}

if ([string]::IsNullOrEmpty($Prompt)) { exit 0 }

$Patterns = @(
    "claude.ai/design",
    "claude design handoff",
    "send to local coding agent",
    "handoff from claude design",
    "design spec from claude",
    "Claude Design export"
)

$Matched = $null
foreach ($p in $Patterns) {
    if ($Prompt -match [regex]::Escape($p)) {
        $Matched = $p
        break
    }
}

if (-not $Matched) { exit 0 }

$Msg = "PDL AUTO-DETECT: handoff pattern from Claude Design detected ('$Matched'). Recommendation: start /picasso --design-loop for the bidirectional Claude Code <-> Claude Design bridge with gate 9.0 and automated fidelity scoring. See docs/BRIDGE-LOOP.md."

$Out = @{
    hookSpecificOutput = @{
        hookEventName = "UserPromptSubmit"
        additionalContext = $Msg
    }
} | ConvertTo-Json -Depth 5 -Compress

Write-Output $Out
