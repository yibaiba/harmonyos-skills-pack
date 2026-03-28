#!/usr/bin/env bash
# PostToolUse Hook: 编辑 module.json5 后检查是否新增了 ACL 受限权限
# 适用于: Claude Code / GitHub Copilot / Codex CLI
# 输入: stdin JSON（Claude: tool_input.path / Copilot: toolArgs 含 path）
# 输出: 告警信息（Agent 可见）

set -euo pipefail

INPUT=$(cat)

# --- 提取文件路径（兼容三平台） ---
FILE_PATH=""

# 1) Claude: "file_path" 或 "path"
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/' 2>/dev/null || echo "")
if [ -z "$FILE_PATH" ]; then
  FILE_PATH=$(echo "$INPUT" | grep -o '"path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/' 2>/dev/null || echo "")
fi

# 2) Copilot: toolArgs JSON 字符串中的 \"path\":\"xxx\"
if [ -z "$FILE_PATH" ]; then
  FILE_PATH=$(echo "$INPUT" | grep -o '\\"path\\"[[:space:]]*:[[:space:]]*\\"[^\\]*\\"' | head -1 | sed 's/.*\\"path\\"[[:space:]]*:[[:space:]]*\\"\([^\\]*\)\\".*/\1/' 2>/dev/null || echo "")
fi

# 仅对 module.json5 触发
case "$FILE_PATH" in
  *module.json5)
    ;;
  *)
    exit 0
    ;;
esac

if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# ACL 受限权限列表（system_basic 级，需要 AGC 审批）
ACL_PERMISSIONS=(
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

FOUND=()

for perm in "${ACL_PERMISSIONS[@]}"; do
  if grep -q "$perm" "$FILE_PATH" 2>/dev/null; then
    FOUND+=("$perm")
  fi
done

if [ ${#FOUND[@]} -gt 0 ]; then
  echo ""
  echo "⚠️  [ACL Hook] 检测到 system_basic 级受限权限:"
  for p in "${FOUND[@]}"; do
    echo "  → $p"
  done
  echo ""
  echo "📋 这些权限需要 AGC 平台 ACL 申请审批（1-2 工作日）。"
  echo "💡 建议先确认是否有替代方案（Picker / 安全控件）。"
  echo "📖 参考: skills/harmonyos-ark/topics/acl-permissions.md"
  echo ""
fi
