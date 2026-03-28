# PostToolUse Hook: 编辑 .ets/.ts 文件后自动运行 ArkTS 现代化守卫扫描
# 适用于: Claude Code / GitHub Copilot / Codex CLI (Windows)
# 输入: stdin JSON（Claude: tool_input.path / Copilot: toolArgs 含 path）
# 输出: 扫描结果（Agent 可见）

$ErrorActionPreference = "SilentlyContinue"

# 从 stdin 读取 hook 输入
$RawInput = $null
try {
    $RawInput = [Console]::In.ReadToEnd()
    $ParsedInput = $RawInput | ConvertFrom-Json
} catch {
    $ParsedInput = $null
}

# --- 提取文件路径（兼容三平台） ---
$FilePath = ""

# 1) Claude 格式: file_path 或 tool_input.path
if ($ParsedInput -and $ParsedInput.file_path) {
    $FilePath = $ParsedInput.file_path
} elseif ($ParsedInput -and $ParsedInput.tool_input -and $ParsedInput.tool_input.path) {
    $FilePath = $ParsedInput.tool_input.path
}

# 2) Copilot 格式: toolArgs 是 JSON 字符串
if (-not $FilePath -and $ParsedInput -and $ParsedInput.toolArgs) {
    try {
        $ToolArgs = $ParsedInput.toolArgs | ConvertFrom-Json
        if ($ToolArgs.path) { $FilePath = $ToolArgs.path }
    } catch {}
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
    if ($FilePath) {
        $FileDir = Split-Path -Parent $FilePath
        if ($FileDir -and (Test-Path $FileDir -PathType Container)) {
            Write-Host "[Hook] 🔍 ArkTS 守卫扫描: $FileDir"
            try { pwsh $ScanScript -ScanDir $FileDir } catch {}
        }
    }
}
