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

scan_file() {
  local file="$1"
  local line_num=0
  TOTAL_FILES=$((TOTAL_FILES + 1))

  while IFS= read -r line; do
    line_num=$((line_num + 1))

    # AMG-001: @Prop 函数回调
    if echo "$line" | grep -qE '@Prop\s+\w+\s*:\s*\('; then
      VIOLATIONS+=("[AMG-001] P0  $file:$line_num  @Prop 修饰函数回调 → 移除 @Prop，改为普通成员")
      P0_COUNT=$((P0_COUNT + 1))
    fi

    # AMG-003: FontWeight.Black
    if echo "$line" | grep -qE 'FontWeight\.Black'; then
      VIOLATIONS+=("[AMG-003] P1  $file:$line_num  FontWeight.Black → 使用 FontWeight.Bolder")
      P1_COUNT=$((P1_COUNT + 1))
    fi

    # AMG-004: LengthMetrics 作为值
    if echo "$line" | grep -qE 'LengthMetrics\.(vp|fp|px|lpx)\s*\('; then
      VIOLATIONS+=("[AMG-004] P1  $file:$line_num  LengthMetrics 是类型别名，不可调用 → 直接传数值")
      P1_COUNT=$((P1_COUNT + 1))
    fi

    # AMG-007: 动态 $r()
    if echo "$line" | grep -qE '\$r\s*\([^"'"'"']'; then
      VIOLATIONS+=("[AMG-007] P2  $file:$line_num  动态 \$r() → 使用静态字面量")
      P2_COUNT=$((P2_COUNT + 1))
    fi

    # AMG-008: deprecated API
    if echo "$line" | grep -qE 'router\.(pushUrl|replaceUrl|back)\s*\('; then
      VIOLATIONS+=("[AMG-008] P2  $file:$line_num  deprecated: router API → 使用 Navigation + NavPathStack")
      P2_COUNT=$((P2_COUNT + 1))
    fi
    if echo "$line" | grep -qE '^\s*animateTo\s*\('; then
      VIOLATIONS+=("[AMG-008] P2  $file:$line_num  deprecated: animateTo → 使用 UIContext.animateTo()")
      P2_COUNT=$((P2_COUNT + 1))
    fi
    if echo "$line" | grep -qE 'AlertDialog\.show\s*\('; then
      VIOLATIONS+=("[AMG-008] P2  $file:$line_num  deprecated: AlertDialog.show → UIContext.showAlertDialog()")
      P2_COUNT=$((P2_COUNT + 1))
    fi
    if echo "$line" | grep -qE 'promptAction\.(showDialog|showToast)\s*\('; then
      VIOLATIONS+=("[AMG-008] P2  $file:$line_num  deprecated: promptAction → UIContext.getPromptAction()")
      P2_COUNT=$((P2_COUNT + 1))
    fi

    # AMG-010: 解构声明
    if echo "$line" | grep -qE '(const|let|var)\s+\{[^}]+\}\s*='; then
      VIOLATIONS+=("[AMG-010] P1  $file:$line_num  解构声明 → 逐个赋值")
      P1_COUNT=$((P1_COUNT + 1))
    fi
    if echo "$line" | grep -qE '(const|let|var)\s+\[[^\]]+\]\s*='; then
      VIOLATIONS+=("[AMG-010] P1  $file:$line_num  数组解构声明 → 逐个赋值")
      P1_COUNT=$((P1_COUNT + 1))
    fi

    # AMG-011: any/unknown 类型
    if echo "$line" | grep -qE ':\s*(any|unknown)\b'; then
      VIOLATIONS+=("[AMG-011] P1  $file:$line_num  any/unknown → 使用具体类型或 interface")
      P1_COUNT=$((P1_COUNT + 1))
    fi

  done < "$file"
}

echo "ArkTS 现代化守卫扫描"
echo "扫描目录: $SCAN_DIR"
echo "================================"

# 扫描所有 .ets 和 .ts 文件
while IFS= read -r -d '' file; do
  scan_file "$file"
done < <(find "$SCAN_DIR" -type f \( -name '*.ets' -o -name '*.ts' \) -print0 2>/dev/null)

# 输出结果
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
