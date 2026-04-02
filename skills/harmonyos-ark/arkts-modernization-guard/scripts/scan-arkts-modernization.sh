#!/usr/bin/env bash
# ArkTS 现代化守卫扫描脚本
# 用法: bash scan-arkts-modernization.sh [扫描目录]
# 默认扫描: entry/src/main/ets
# 退出码: 0=passed, 1=failed(P0/P1), 2=warning(仅P2)

set -euo pipefail

SCAN_DIR="${1:-entry/src/main/ets}"
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'

if [ ! -d "$SCAN_DIR" ]; then
  echo "错误: 目录 $SCAN_DIR 不存在"
  echo "用法: bash $0 [扫描目录]"
  exit 1
fi

P0_COUNT=0
P1_COUNT=0
P2_COUNT=0
TOTAL_FILES=0
VIOLATIONS=()
OBSERVED_V2_TYPES=()
FILES=()

contains_observed_v2_type() {
  local target="$1"
  local item
  for item in "${OBSERVED_V2_TYPES[@]-}"; do
    if [ "$item" = "$target" ]; then
      return 0
    fi
  done
  return 1
}

add_observed_v2_type() {
  local class_name="$1"
  if [ -z "$class_name" ]; then
    return
  fi
  if ! contains_observed_v2_type "$class_name"; then
    OBSERVED_V2_TYPES+=("$class_name")
  fi
}

extract_class_name() {
  echo "$1" | sed -nE 's/.*class[[:space:]]+([A-Za-z_][A-Za-z0-9_]*).*/\1/p'
}

extract_type_name() {
  echo "$1" | sed -nE 's/.*:[[:space:]]*([A-Za-z_][A-Za-z0-9_]*).*/\1/p'
}

add_violation() {
  local rule_id="$1"
  local level="$2"
  local file="$3"
  local line_num="$4"
  local message="$5"

  VIOLATIONS+=("[$rule_id] $level  $file:$line_num  $message")
  case "$level" in
    P0) P0_COUNT=$((P0_COUNT + 1)) ;;
    P1) P1_COUNT=$((P1_COUNT + 1)) ;;
    P2) P2_COUNT=$((P2_COUNT + 1)) ;;
  esac
}

collect_observed_v2_types_from_file() {
  local file="$1"
  local line=""
  local observed_pending=0
  local class_name=""

  while IFS= read -r line || [ -n "$line" ]; do
    if echo "$line" | grep -qE '@ObservedV2'; then
      class_name=$(extract_class_name "$line")
      if [ -n "$class_name" ]; then
        add_observed_v2_type "$class_name"
        observed_pending=0
      else
        observed_pending=1
      fi
      continue
    fi

    if [ "$observed_pending" -eq 1 ]; then
      class_name=$(extract_class_name "$line")
      if [ -n "$class_name" ]; then
        add_observed_v2_type "$class_name"
        observed_pending=0
      elif ! echo "$line" | grep -qE '^\s*$|^\s*(//|/\*|\*|\*/|@)'; then
        observed_pending=0
      fi
    fi
  done < "$file"
}

scan_file() {
  local file="$1"
  local line_num=0
  local line=""
  local pending_storage_link=0
  local type_name=""

  TOTAL_FILES=$((TOTAL_FILES + 1))

  while IFS= read -r line || [ -n "$line" ]; do
    line_num=$((line_num + 1))

    if echo "$line" | grep -qE '@(Local)?StorageLink\b'; then
      type_name=$(extract_type_name "$line")
      if [ -n "$type_name" ] && contains_observed_v2_type "$type_name"; then
        add_violation "AMG-013" "P1" "$file" "$line_num" "@StorageLink/@LocalStorageLink 不能绑定 @ObservedV2 class → 改存快照字段，ViewModel 保持页面级"
        pending_storage_link=0
      else
        pending_storage_link=1
      fi
    elif [ "$pending_storage_link" -eq 1 ]; then
      if echo "$line" | grep -qE '^\s*$|^\s*(//|/\*|\*|\*/)'; then
        :
      else
        type_name=$(extract_type_name "$line")
        if [ -n "$type_name" ] && contains_observed_v2_type "$type_name"; then
          add_violation "AMG-013" "P1" "$file" "$line_num" "@StorageLink/@LocalStorageLink 不能绑定 @ObservedV2 class → 改存快照字段，ViewModel 保持页面级"
        fi
        pending_storage_link=0
      fi
    fi

    if echo "$line" | grep -qE '@Prop\s+\w+\s*:\s*\('; then
      add_violation "AMG-001" "P0" "$file" "$line_num" "@Prop 修饰函数回调 → 移除 @Prop，改为普通成员"
    fi

    if echo "$line" | grep -qE 'FontWeight\.Black'; then
      add_violation "AMG-003" "P1" "$file" "$line_num" "FontWeight.Black → 使用 FontWeight.Bolder"
    fi

    if echo "$line" | grep -qE 'LengthMetrics\.(vp|fp|px|lpx)\s*\('; then
      add_violation "AMG-004" "P1" "$file" "$line_num" "LengthMetrics 是类型别名，不可调用 → 直接传数值"
    fi

    if echo "$line" | grep -qE "\\\$r[[:space:]]*\\([^\"']"; then
      add_violation "AMG-007" "P2" "$file" "$line_num" "动态 \\$r() → 使用静态字面量"
    fi

    if echo "$line" | grep -qE 'router\.(pushUrl|replaceUrl|back)\s*\('; then
      add_violation "AMG-008" "P2" "$file" "$line_num" "deprecated: router API → 使用 Navigation + NavPathStack"
    fi
    if echo "$line" | grep -qE '^\s*animateTo\s*\('; then
      add_violation "AMG-008" "P2" "$file" "$line_num" "deprecated: animateTo → 使用 UIContext.animateTo()"
    fi
    if echo "$line" | grep -qE 'AlertDialog\.show\s*\('; then
      add_violation "AMG-008" "P2" "$file" "$line_num" "deprecated: AlertDialog.show → UIContext.showAlertDialog()"
    fi
    if echo "$line" | grep -qE 'promptAction\.(showDialog|showToast)\s*\('; then
      add_violation "AMG-008" "P2" "$file" "$line_num" "deprecated: promptAction → UIContext.getPromptAction()"
    fi

    if echo "$line" | grep -qE 'sys\.symbol\.[A-Za-z0-9_]+'; then
      add_violation "AMG-009" "P2" "$file" "$line_num" "sys.symbol.* 资源名需在当前 SDK 验证 → 用前先查 DevEco 资源面板"
    fi

    if echo "$line" | grep -qE '(const|let|var)\s+\{[^}]+\}\s*='; then
      add_violation "AMG-010" "P1" "$file" "$line_num" "解构声明 → 逐个赋值"
    fi
    if echo "$line" | grep -qE '(const|let|var)\s+\[[^]]+\]\s*='; then
      add_violation "AMG-010" "P1" "$file" "$line_num" "数组解构声明 → 逐个赋值"
    fi

    if echo "$line" | grep -qE ':\s*(any|unknown)\b'; then
      add_violation "AMG-011" "P1" "$file" "$line_num" "any/unknown → 使用具体类型或 interface"
    fi

    if echo "$line" | grep -qE "throw[[:space:]]+(\{|\\[|\"[^\"]*\"|'[^']*'|[0-9]+|true|false|null|undefined)"; then
      add_violation "AMG-012" "P1" "$file" "$line_num" "throw 非 Error → 改为 throw new Error(...) 或 Error 子类"
    fi

    if echo "$line" | grep -qE 'ohos_ic_public_[A-Za-z0-9_]+'; then
      add_violation "AMG-014" "P2" "$file" "$line_num" "ohos_ic_public_* 资源名需在当前 SDK 验证 → 拿不准时改本地图标"
    fi
  done < "$file"
}

echo "ArkTS 现代化守卫扫描"
echo "扫描目录: $SCAN_DIR"
echo "================================"

while IFS= read -r -d '' file; do
  FILES+=("$file")
  collect_observed_v2_types_from_file "$file"
done < <(find "$SCAN_DIR" -type f \( -name '*.ets' -o -name '*.ts' \) -print0 2>/dev/null)

for file in "${FILES[@]-}"; do
  scan_file "$file"
done

if [ ${#VIOLATIONS[@]} -gt 0 ]; then
  echo ""
  for v in "${VIOLATIONS[@]}"; do
    if echo "$v" | grep -q "P0"; then
      echo -e "${RED}$v${NC}"
    elif echo "$v" | grep -q "P1"; then
      echo -e "${YELLOW}$v${NC}"
    else
      echo "$v"
    fi
  done
fi

echo ""
echo "================================"
echo "扫描完成: $TOTAL_FILES 个文件, $((P0_COUNT + P1_COUNT + P2_COUNT)) 个违规 ($P0_COUNT P0, $P1_COUNT P1, $P2_COUNT P2)"

if [ $P0_COUNT -gt 0 ] || [ $P1_COUNT -gt 0 ]; then
  echo -e "${RED}结果: FAILED${NC}"
  exit 1
elif [ $P2_COUNT -gt 0 ]; then
  echo -e "${YELLOW}结果: WARNING${NC}"
  exit 2
else
  echo -e "${GREEN}结果: PASSED${NC}"
  exit 0
fi
