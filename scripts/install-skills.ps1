# HarmonyOS Skills 安装脚本 (PowerShell)
# 用法: pwsh install-skills.ps1 [-Claude] [-CopilotWorkspace <path>] [-Codex <path>] [-All] [-Force]

param(
    [switch]$Claude,
    [ValidateNotNullOrEmpty()]
    [string]$CopilotWorkspace,
    [ValidateNotNullOrEmpty()]
    [string]$Codex,
    [switch]$All,
    [switch]$Force,
    [switch]$Help
)

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$SourceClaudeDir = Join-Path $RepoRoot ".claude" "skills"
$SourceGithubDir = Join-Path $RepoRoot ".github" "skills"

$Skills = @("harmonyos-ark", "universal-product-quality")

function Show-Usage {
    Write-Host @"
Usage:
  pwsh install-skills.ps1 [-Claude] [-CopilotWorkspace <path>] [-Codex <path>] [-All] [-Force]

Options:
  -Claude                      Install skills to ~/.claude/skills (default on if no option)
  -CopilotWorkspace <path>     Install skills to <path>/.github/skills
  -Codex <path>                Install skills to <path>/.codex/skills
  -All                         Install to all targets (claude + copilot-workspace + codex in current dir)
  -Force                       Overwrite existing target skill directories
  -Help                        Show help

Examples:
  pwsh install-skills.ps1 -Claude
  pwsh install-skills.ps1 -CopilotWorkspace C:\Code\my-app
  pwsh install-skills.ps1 -Codex C:\Code\my-app
  pwsh install-skills.ps1 -All -Force
"@
}

if ($Help) {
    Show-Usage
    exit 0
}

# 无参数时默认安装到 Claude
if (-not $Claude -and -not $CopilotWorkspace -and -not $Codex -and -not $All) {
    $Claude = $true
}

if ($All) {
    $Claude = $true
    if (-not $CopilotWorkspace) { $CopilotWorkspace = Get-Location }
    if (-not $Codex) { $Codex = Get-Location }
}

function Copy-Skill {
    param(
        [string]$Src,
        [string]$Dst
    )

    if (Test-Path $Dst) {
        if ($Force) {
            Remove-Item -Recurse -Force $Dst
        } else {
            Write-Host "Skip existing: $Dst (use -Force to overwrite)"
            return
        }
    }

    $parentDir = Split-Path -Parent $Dst
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    Copy-Item -Recurse -Path $Src -Destination $Dst
    Write-Host "Installed: $Dst"
}

if ($Claude) {
    $claudeTarget = Join-Path $HOME ".claude" "skills"
    if (-not (Test-Path $claudeTarget)) {
        New-Item -ItemType Directory -Path $claudeTarget -Force | Out-Null
    }
    foreach ($skill in $Skills) {
        Copy-Skill -Src (Join-Path $SourceClaudeDir $skill) -Dst (Join-Path $claudeTarget $skill)
    }
}

if ($CopilotWorkspace) {
    if (-not (Test-Path $CopilotWorkspace -PathType Container)) {
        Write-Host "Workspace not found: $CopilotWorkspace" -ForegroundColor Red
        exit 1
    }
    $copilotTarget = Join-Path $CopilotWorkspace ".github" "skills"
    if (-not (Test-Path $copilotTarget)) {
        New-Item -ItemType Directory -Path $copilotTarget -Force | Out-Null
    }
    foreach ($skill in $Skills) {
        Copy-Skill -Src (Join-Path $SourceGithubDir $skill) -Dst (Join-Path $copilotTarget $skill)
    }
}

if ($Codex) {
    if (-not (Test-Path $Codex -PathType Container)) {
        Write-Host "Workspace not found: $Codex" -ForegroundColor Red
        exit 1
    }
    $codexTarget = Join-Path $Codex ".codex" "skills"
    if (-not (Test-Path $codexTarget)) {
        New-Item -ItemType Directory -Path $codexTarget -Force | Out-Null
    }
    foreach ($skill in $Skills) {
        Copy-Skill -Src (Join-Path $SourceGithubDir $skill) -Dst (Join-Path $codexTarget $skill)
    }
}

Write-Host "Done."
