# HarmonyOS Skills 卸载脚本 (PowerShell)
# 用法: pwsh uninstall-skills.ps1 [-Claude] [-CopilotWorkspace <path>] [-Codex <path>] [-All]

param(
    [switch]$Claude,
    [ValidateNotNullOrEmpty()]
    [string]$CopilotWorkspace,
    [ValidateNotNullOrEmpty()]
    [string]$Codex,
    [switch]$All,
    [switch]$Help
)

$ErrorActionPreference = "Stop"

$Skills = @("harmonyos-ark", "universal-product-quality")

function Show-Usage {
    Write-Host @"
Usage:
  pwsh uninstall-skills.ps1 [-Claude] [-CopilotWorkspace <path>] [-Codex <path>] [-All]

Options:
  -Claude                      Uninstall from ~/.claude/skills (default on if no option)
  -CopilotWorkspace <path>     Uninstall from <path>/.github/skills
  -Codex <path>                Uninstall from <path>/.codex/skills
  -All                         Uninstall from all targets (claude + copilot-workspace + codex in current dir)
  -Help                        Show help

Examples:
  pwsh uninstall-skills.ps1 -Claude
  pwsh uninstall-skills.ps1 -CopilotWorkspace C:\Code\my-app
  pwsh uninstall-skills.ps1 -Codex C:\Code\my-app
  pwsh uninstall-skills.ps1 -All
"@
}

if ($Help) {
    Show-Usage
    exit 0
}

# 无参数时默认卸载 Claude
if (-not $Claude -and -not $CopilotWorkspace -and -not $Codex -and -not $All) {
    $Claude = $true
}

if ($All) {
    $Claude = $true
    if (-not $CopilotWorkspace) { $CopilotWorkspace = Get-Location }
    if (-not $Codex) { $Codex = Get-Location }
}

function Remove-IfExists {
    param([string]$Path)

    if (Test-Path $Path) {
        Remove-Item -Recurse -Force $Path
        Write-Host "Removed: $Path"
    } else {
        Write-Host "Not found: $Path"
    }
}

if ($Claude) {
    foreach ($skill in $Skills) {
        Remove-IfExists -Path (Join-Path $HOME ".claude" "skills" $skill)
    }
}

if ($CopilotWorkspace) {
    foreach ($skill in $Skills) {
        Remove-IfExists -Path (Join-Path $CopilotWorkspace ".github" "skills" $skill)
    }
}

if ($Codex) {
    foreach ($skill in $Skills) {
        Remove-IfExists -Path (Join-Path $Codex ".codex" "skills" $skill)
    }
}

Write-Host "Done."
