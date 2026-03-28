#!/usr/bin/env bash
# PostToolUse Hook: 编辑 .ets/.ts 文件后自动运行 ArkTS 现代化守卫扫描
# 适用于: Claude Code / GitHub Copilot / Codex CLI
# 输入: stdin JSON（Claude: tool_input.path / Copilot: toolArgs 含 path）
# 输出: 扫描结果（Agent 可见）

set -euo pipefail

# 从 stdin 读取 hook 输入（JSON）
INPUT=$(cat)

# --- 提取文件路径（兼容 Claude / Copilot / Codex 三种 JSON 格式） ---

FILE_PATH=""

# 1) Claude 格式: "file_path": "xxx" 或 tool_input.path
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/' 2>/dev/null || echo "")
if [ -z "$FILE_PATH" ]; then
  FILE_PATH=$(echo "$INPUT" | grep -o '"path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/' 2>/dev/null || echo "")
fi

# 2) Copilot 格式: toolArgs 是 JSON 字符串，内含 \"path\":\"xxx\"
if [ -z "$FILE_PATH" ]; then
  FILE_PATH=$(echo "$INPUT" | grep -o '\\"path\\"[[:space:]]*:[[:space:]]*\\"[^\\]*\\"' | head -1 | sed 's/.*\\"path\\"[[:space:]]*:[[:space:]]*\\"\([^\\]*\)\\".*/\1/' 2>/dev/null || echo "")
fi

# 3) 兜底: Codex post_run 无文件信息，直接扫描默认目录
# （FILE_PATH 为空时后续逻辑会扫描 entry/src/main/ets）

# 仅对 .ets 和 .ts 文件触发扫描
case "$FILE_PATH" in
  *.ets|*.ts)
    ;;
  *)
    exit 0
    ;;
esac

# 查找扫描脚本
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCAN_SCRIPT=""

# 优先查找同级 arkts-modernization-guard
for candidate in \
  "$SCRIPT_DIR/../arkts-modernization-guard/scripts/scan-arkts-modernization.sh" \
  ".claude/skills/harmonyos-ark/arkts-modernization-guard/scripts/scan-arkts-modernization.sh" \
  ".github/skills/harmonyos-ark/arkts-modernization-guard/scripts/scan-arkts-modernization.sh" \
  ".codex/skills/harmonyos-ark/arkts-modernization-guard/scripts/scan-arkts-modernization.sh"; do
  if [ -f "$candidate" ]; then
    SCAN_SCRIPT="$candidate"
    break
  fi
done

if [ -z "$SCAN_SCRIPT" ]; then
  echo "[Hook] ArkTS 守卫扫描脚本未找到，跳过"
  exit 0
fi

# 确定扫描目录（从文件路径推断项目的 ets 源码目录）
SCAN_DIR="entry/src/main/ets"
if [ -d "$SCAN_DIR" ]; then
  echo "[Hook] 🔍 ArkTS 守卫扫描中..."
  bash "$SCAN_SCRIPT" "$SCAN_DIR" 2>&1 || true
else
  # 扫描文件所在目录
  FILE_DIR=$(dirname "$FILE_PATH")
  if [ -d "$FILE_DIR" ]; then
    echo "[Hook] 🔍 ArkTS 守卫扫描: $FILE_DIR"
    bash "$SCAN_SCRIPT" "$FILE_DIR" 2>&1 || true
  fi
fi
