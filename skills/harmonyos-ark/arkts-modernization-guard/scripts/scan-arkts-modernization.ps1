# ArkTS 现代化守卫扫描脚本 (PowerShell)
# 用法: pwsh scan-arkts-modernization.ps1 [-ScanDir <目录>]
# 默认扫描: entry\src\main\ets
# 退出码: 0=passed, 1=failed(P0/P1), 2=warning(仅P2)

param(
    [string]$ScanDir = (Join-Path "entry" "src" "main" "ets")
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $ScanDir -PathType Container)) {
    Write-Host "错误: 目录 $ScanDir 不存在" -ForegroundColor Red
    Write-Host "用法: pwsh $($MyInvocation.MyCommand.Name) [-ScanDir <目录>]"
    exit 1
}

$P0Count = 0
$P1Count = 0
$P2Count = 0
$TotalFiles = 0
$Violations = [System.Collections.ArrayList]::new()
$ObservedV2Types = [System.Collections.Generic.HashSet[string]]::new()

$Rules = @(
    @{ Id = "AMG-001"; Level = "P0"; Pattern = '@Prop\s+\w+\s*:\s*\('; Msg = "@Prop 修饰函数回调 → 移除 @Prop，改为普通成员" }
    @{ Id = "AMG-003"; Level = "P1"; Pattern = 'FontWeight\.Black'; Msg = "FontWeight.Black → 使用 FontWeight.Bolder" }
    @{ Id = "AMG-004"; Level = "P1"; Pattern = 'LengthMetrics\.(vp|fp|px|lpx)\s*\('; Msg = "LengthMetrics 是类型别名，不可调用 → 直接传数值" }
    @{ Id = "AMG-007"; Level = "P2"; Pattern = '\$r\s*\([^"''']'; Msg = '动态 $r() → 使用静态字面量' }
    @{ Id = "AMG-008a"; Level = "P2"; Pattern = 'router\.(pushUrl|replaceUrl|back)\s*\('; Msg = "deprecated: router API → 使用 Navigation + NavPathStack" }
    @{ Id = "AMG-008b"; Level = "P2"; Pattern = '^\s*animateTo\s*\('; Msg = "deprecated: animateTo → 使用 UIContext.animateTo()" }
    @{ Id = "AMG-008c"; Level = "P2"; Pattern = 'AlertDialog\.show\s*\('; Msg = "deprecated: AlertDialog.show → UIContext.showAlertDialog()" }
    @{ Id = "AMG-008d"; Level = "P2"; Pattern = 'promptAction\.(showDialog|showToast)\s*\('; Msg = "deprecated: promptAction → UIContext.getPromptAction()" }
    @{ Id = "AMG-009"; Level = "P2"; Pattern = 'sys\.symbol\.[A-Za-z0-9_]+'; Msg = "sys.symbol.* 资源名需在当前 SDK 验证 → 用前先查 DevEco 资源面板" }
    @{ Id = "AMG-010a"; Level = "P1"; Pattern = '(const|let|var)\s+\{[^}]+\}\s*='; Msg = "解构声明 → 逐个赋值" }
    @{ Id = "AMG-010b"; Level = "P1"; Pattern = '(const|let|var)\s+\[[^\]]+\]\s*='; Msg = "数组解构声明 → 逐个赋值" }
    @{ Id = "AMG-011"; Level = "P1"; Pattern = ':\s*(any|unknown)\b'; Msg = "any/unknown → 使用具体类型或 interface" }
    @{ Id = "AMG-012"; Level = "P1"; Pattern = 'throw\s+(\{|\[|"[^"]*"|''[^'']*''|[0-9]+|true|false|null|undefined)'; Msg = "throw 非 Error → 改为 throw new Error(...) 或 Error 子类" }
    @{ Id = "AMG-014"; Level = "P2"; Pattern = 'ohos_ic_public_[A-Za-z0-9_]+'; Msg = "ohos_ic_public_* 资源名需在当前 SDK 验证 → 拿不准时改本地图标" }
)

function Add-Violation {
    param(
        [string]$RuleId,
        [string]$Level,
        [string]$FilePath,
        [int]$LineNumber,
        [string]$Message
    )

    $entry = "[$RuleId] $Level  ${FilePath}:${LineNumber}  $Message"
    [void]$script:Violations.Add($entry)
    switch ($Level) {
        "P0" { $script:P0Count++ }
        "P1" { $script:P1Count++ }
        "P2" { $script:P2Count++ }
    }
}

function Get-ClassNameFromLine {
    param([string]$Line)

    if ($Line -match 'class\s+([A-Za-z_][A-Za-z0-9_]*)') {
        return $Matches[1]
    }
    return $null
}

function Get-TypeNameFromLine {
    param([string]$Line)

    if ($Line -match ':\s*([A-Za-z_][A-Za-z0-9_]*)') {
        return $Matches[1]
    }
    return $null
}

function Collect-ObservedV2Types {
    param([string]$FilePath)

    $observedPending = $false
    $lines = Get-Content -Path $FilePath -Encoding UTF8

    foreach ($line in $lines) {
        if ($line -match '@ObservedV2') {
            $className = Get-ClassNameFromLine -Line $line
            if ($className) {
                [void]$script:ObservedV2Types.Add($className)
                $observedPending = $false
            } else {
                $observedPending = $true
            }
            continue
        }

        if ($observedPending) {
            $className = Get-ClassNameFromLine -Line $line
            if ($className) {
                [void]$script:ObservedV2Types.Add($className)
                $observedPending = $false
            } elseif ($line -notmatch '^\s*$' -and $line -notmatch '^\s*(//|/\*|\*|\*/|@)') {
                $observedPending = $false
            }
        }
    }
}

function Scan-File {
    param([string]$FilePath)

    $script:TotalFiles++
    $lines = Get-Content -Path $FilePath -Encoding UTF8
    $lineNum = 0
    $pendingStorageLink = $false

    foreach ($line in $lines) {
        $lineNum++

        if ($line -match '@(Local)?StorageLink\b') {
            $typeName = Get-TypeNameFromLine -Line $line
            if ($typeName -and $script:ObservedV2Types.Contains($typeName)) {
                Add-Violation -RuleId "AMG-013" -Level "P1" -FilePath $FilePath -LineNumber $lineNum -Message "@StorageLink/@LocalStorageLink 不能绑定 @ObservedV2 class → 改存快照字段，ViewModel 保持页面级"
                $pendingStorageLink = $false
            } else {
                $pendingStorageLink = $true
            }
        } elseif ($pendingStorageLink) {
            if ($line -match '^\s*$' -or $line -match '^\s*(//|/\*|\*|\*/)') {
                # wait for the property line
            } else {
                $typeName = Get-TypeNameFromLine -Line $line
                if ($typeName -and $script:ObservedV2Types.Contains($typeName)) {
                    Add-Violation -RuleId "AMG-013" -Level "P1" -FilePath $FilePath -LineNumber $lineNum -Message "@StorageLink/@LocalStorageLink 不能绑定 @ObservedV2 class → 改存快照字段，ViewModel 保持页面级"
                }
                $pendingStorageLink = $false
            }
        }

        foreach ($rule in $Rules) {
            if ($line -match $rule.Pattern) {
                $ruleId = ($rule.Id -replace '[a-d]$', '')
                Add-Violation -RuleId $ruleId -Level $rule.Level -FilePath $FilePath -LineNumber $lineNum -Message $rule.Msg
            }
        }
    }
}

Write-Host "ArkTS 现代化守卫扫描"
Write-Host "扫描目录: $ScanDir"
Write-Host "================================"

$files = Get-ChildItem -Path $ScanDir -Recurse -Include *.ets, *.ts -File -ErrorAction SilentlyContinue
foreach ($file in $files) {
    Collect-ObservedV2Types -FilePath $file.FullName
}
foreach ($file in $files) {
    Scan-File -FilePath $file.FullName
}

if ($Violations.Count -gt 0) {
    Write-Host ""
    foreach ($v in $Violations) {
        if ($v -match "P0") {
            Write-Host $v -ForegroundColor Red
        } elseif ($v -match "P1") {
            Write-Host $v -ForegroundColor Yellow
        } else {
            Write-Host $v
        }
    }
}

$totalViolations = $P0Count + $P1Count + $P2Count
Write-Host ""
Write-Host "================================"
Write-Host "扫描完成: $TotalFiles 个文件, $totalViolations 个违规 ($P0Count P0, $P1Count P1, $P2Count P2)"

if ($P0Count -gt 0 -or $P1Count -gt 0) {
    Write-Host "结果: FAILED" -ForegroundColor Red
    exit 1
} elseif ($P2Count -gt 0) {
    Write-Host "结果: WARNING" -ForegroundColor Yellow
    exit 2
} else {
    Write-Host "结果: PASSED" -ForegroundColor Green
    exit 0
}
