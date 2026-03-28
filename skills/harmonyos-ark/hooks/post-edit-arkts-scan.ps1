# PostToolUse Hook: 编辑 .ets/.ts 文件后自动运行 ArkTS 现代化守卫扫描
# 适用于: Claude Code / GitHub Copilot / Codex CLI (Windows)
# 输入: stdin JSON（包含 tool_name, file_path 等）
# 输出: 扫描结果（Agent 可见）

$ErrorActionPreference = "SilentlyContinue"

# 从 stdin 读取 hook 输入
$Input = $null
try {
    $Input = [Console]::In.ReadToEnd() | ConvertFrom-Json
} catch {
    $Input = $null
}

# 提取文件路径
$FilePath = ""
if ($Input -and $Input.file_path) {
    $FilePath = $Input.file_path
} elseif ($Input -and $Input.tool_input -and $Input.tool_input.path) {
    $FilePath = $Input.tool_input.path
}

# 仅对 .ets 和 .ts 文件触发
if ($FilePath -notmatch '\.(ets|ts)$') {
    exit 0
}

# 查找扫描脚本
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ScanScript = $null

$Candidates = @(
    (Join-Path $ScriptDir ".." "arkts-modernization-guard" "scripts" "scan-arkts-modernization.ps1"),
    (Join-Path "." ".claude" "skills" "harmonyos-ark" "arkts-modernization-guard" "scripts" "scan-arkts-modernization.ps1"),
    (Join-Path "." ".github" "skills" "harmonyos-ark" "arkts-modernization-guard" "scripts" "scan-arkts-modernization.ps1"),
    (Join-Path "." ".codex" "skills" "harmonyos-ark" "arkts-modernization-guard" "scripts" "scan-arkts-modernization.ps1")
)

foreach ($candidate in $Candidates) {
    if (Test-Path $candidate) {
        $ScanScript = $candidate
        break
    }
}

if (-not $ScanScript) {
    Write-Host "[Hook] ArkTS 守卫扫描脚本未找到，跳过"
    exit 0
}

# 确定扫描目录
$ScanDir = Join-Path "entry" "src" "main" "ets"
if (Test-Path $ScanDir -PathType Container) {
    Write-Host "[Hook] 🔍 ArkTS 守卫扫描中..."
    try { pwsh $ScanScript -ScanDir $ScanDir } catch {}
} else {
    $FileDir = Split-Path -Parent $FilePath
    if ($FileDir -and (Test-Path $FileDir -PathType Container)) {
        Write-Host "[Hook] 🔍 ArkTS 守卫扫描: $FileDir"
        try { pwsh $ScanScript -ScanDir $FileDir } catch {}
    }
}
