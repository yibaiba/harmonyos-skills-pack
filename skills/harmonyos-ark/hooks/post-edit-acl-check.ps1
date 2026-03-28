# PostToolUse Hook: 编辑 module.json5 后检查是否新增了 ACL 受限权限
# 适用于: Claude Code / GitHub Copilot / Codex CLI (Windows)
# 输入: stdin JSON
# 输出: 告警信息（Agent 可见）

$ErrorActionPreference = "SilentlyContinue"

$Input = $null
try {
    $Input = [Console]::In.ReadToEnd() | ConvertFrom-Json
} catch {
    $Input = $null
}

$FilePath = ""
if ($Input -and $Input.file_path) {
    $FilePath = $Input.file_path
} elseif ($Input -and $Input.tool_input -and $Input.tool_input.path) {
    $FilePath = $Input.tool_input.path
}

# 仅对 module.json5 触发
if ($FilePath -notmatch 'module\.json5$') {
    exit 0
}

if (-not (Test-Path $FilePath)) {
    exit 0
}

# ACL 受限权限列表
$AclPermissions = @(
    "ohos.permission.READ_IMAGEVIDEO"
    "ohos.permission.WRITE_IMAGEVIDEO"
    "ohos.permission.READ_AUDIO"
    "ohos.permission.WRITE_AUDIO"
    "ohos.permission.READ_DOCUMENT"
    "ohos.permission.WRITE_DOCUMENT"
    "ohos.permission.READ_MEDIA"
    "ohos.permission.WRITE_MEDIA"
    "ohos.permission.READ_CONTACTS"
    "ohos.permission.WRITE_CONTACTS"
    "ohos.permission.READ_CALL_LOG"
    "ohos.permission.WRITE_CALL_LOG"
    "ohos.permission.SEND_MESSAGES"
    "ohos.permission.PLACE_CALL"
    "ohos.permission.SYSTEM_FLOAT_WINDOW"
    "ohos.permission.READ_PASTEBOARD"
    "ohos.permission.DISTRIBUTED_DATASYNC"
    "ohos.permission.LOCATION_IN_BACKGROUND"
    "ohos.permission.MEDIA_LOCATION"
)

$content = Get-Content -Path $FilePath -Raw -ErrorAction SilentlyContinue
$Found = @()

foreach ($perm in $AclPermissions) {
    if ($content -match [regex]::Escape($perm)) {
        $Found += $perm
    }
}

if ($Found.Count -gt 0) {
    Write-Host ""
    Write-Host "⚠️  [ACL Hook] 检测到 system_basic 级受限权限:" -ForegroundColor Yellow
    foreach ($p in $Found) {
        Write-Host "  → $p" -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "📋 这些权限需要 AGC 平台 ACL 申请审批（1-2 工作日）。"
    Write-Host "💡 建议先确认是否有替代方案（Picker / 安全控件）。"
    Write-Host "📖 参考: skills/harmonyos-ark/topics/acl-permissions.md"
    Write-Host ""
}
