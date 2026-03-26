#!/bin/bash

# validate-skills.sh - 预发布验证脚本  
# 检查核心技能包的完整性和一致性

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

TOTAL=0
PASSED=0
FAILED=0

check() {
  TOTAL=$((TOTAL + 1))
  if [[ $? -eq 0 ]]; then
    PASSED=$((PASSED + 1))
    echo -e "${GREEN}✓ $1${NC}"
  else
    FAILED=$((FAILED + 1))
    echo -e "${RED}✗ $1${NC}"
  fi
}

echo -e "${BLUE}════════════════════════════════════════════${NC}"
echo -e "${BLUE}  核心技能包预发布验证${NC}"
echo -e "${BLUE}════════════════════════════════════════════${NC}"
echo ""

# 检查核心目录
echo -e "${CYAN}1️⃣  目录检查${NC}"
test -d "$PROJECT_ROOT/.claude/skills"
check ".claude/skills 存在"

test -d "$PROJECT_ROOT/.github/skills"
check ".github/skills 存在"

# 检查核心技能
echo ""
echo -e "${CYAN}2️⃣  核心技能检查${NC}"

CORE_SKILLS=("harmonyos-ark" "universal-product-quality")

for skill in "${CORE_SKILLS[@]}"; do
  test -d "$PROJECT_ROOT/.claude/skills/$skill"
  check ".claude/skills/$skill"
  
  test -d "$PROJECT_ROOT/.github/skills/$skill"
  check ".github/skills/$skill"
done

# 检查 SKILL.md 文件
echo ""
echo -e "${CYAN}3️⃣  Frontmatter 检查${NC}"

for skill in "${CORE_SKILLS[@]}"; do
  for platform in .claude .github; do
    file="$PROJECT_ROOT/$platform/skills/$skill/SKILL.md"
    if [[ -f "$file" ]]; then
      head -1 "$file" | grep -q "^---"
      check "$platform/skills/$skill/SKILL.md frontmatter valid"
    fi
  done
done

# 检查跨平台一致性（核心技能）
echo ""
echo -e "${CYAN}4️⃣  跨平台一致性${NC}"

for skill in "${CORE_SKILLS[@]}"; do
  CLAUDE_FILES=$(find "$PROJECT_ROOT/.claude/skills/$skill" -type f | wc -l)
  GITHUB_FILES=$(find "$PROJECT_ROOT/.github/skills/$skill" -type f | wc -l)
  
  if [[ $CLAUDE_FILES -eq $GITHUB_FILES ]]; then
    PASSED=$((PASSED + 1))
    echo -e "${GREEN}✓ $skill 文件计数一致 ($CLAUDE_FILES)${NC}"
  else
    echo -e "${YELLOW}⚠ $skill 文件数差异: Claude=$CLAUDE_FILES, GitHub=$GITHUB_FILES${NC}"
  fi
  TOTAL=$((TOTAL + 1))
done

# 检查版本
echo ""
echo -e "${CYAN}5️⃣  版本检查${NC}"

VERSION=$(cat "$PROJECT_ROOT/VERSION" | tr -d ' \n' 2>/dev/null || echo "")
if [[ -n "$VERSION" ]] && [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  PASSED=$((PASSED + 1))
  echo -e "${GREEN}✓ VERSION 有效: $VERSION${NC}"
else
  FAILED=$((FAILED + 1))
  echo -e "${RED}✗ VERSION 格式错误${NC}"
fi
TOTAL=$((TOTAL + 1))

# 检查必要文档
echo ""
echo -e "${CYAN}6️⃣  文档检查${NC}"

DOCS=("README.md" "CHANGELOG.md" "INSTALL_VERIFICATION.md")
for doc in "${DOCS[@]}"; do
  test -f "$PROJECT_ROOT/$doc"
  check "$doc 存在"
done

# 最终报告
echo ""
echo -e "${BLUE}════════════════════════════════════════════${NC}"
echo -e "${BLUE}  验证结果${NC}"
echo -e "${BLUE}════════════════════════════════════════════${NC}"
echo ""
echo "总检查数: $TOTAL"
echo -e "${GREEN}通过: $PASSED ✓${NC}"
echo -e "${RED}失败: $FAILED ✗${NC}"
echo ""

if [[ $FAILED -eq 0 ]]; then
  echo -e "${GREEN}✅ 验证通过 - 技能包已就绪发布${NC}"
  exit 0
else
  echo -e "${RED}❌ 验证失败 - 请修复问题后重试${NC}"
  exit 1
fi
