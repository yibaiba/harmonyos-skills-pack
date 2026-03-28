#!/bin/bash

# make-release.sh – 生成语义版本化发布包
# 用法: make-release.sh [--tag] [--force] [--help]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
VERSION_FILE="$PROJECT_ROOT/VERSION"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 显示帮助
show_help() {
  cat << 'HELP'
用法: ./scripts/make-release.sh [选项]

选项:
  --tag      创建 Git tag (v{VERSION}) 并推送提示
  --force    跳过 Git 状态检查
  --help     显示此帮助信息

示例:
  ./scripts/make-release.sh
  ./scripts/make-release.sh --tag
  ./scripts/make-release.sh --force --tag

发布包位置: releases/harmonyos-skills-{VERSION}.zip
HELP
exit 0
}

# 参数解析
TAG_RELEASE=false
FORCE=false

case "${1:-}" in
  --help) show_help ;;
  *)
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --tag)   TAG_RELEASE=true; shift ;;
        --force) FORCE=true; shift ;;
        *)       echo -e "${RED}❌ 未知参数: $1${NC}"; show_help ;;
      esac
    done
    ;;
esac

# 检查版本文件
if [[ ! -f "$VERSION_FILE" ]]; then
  echo -e "${RED}❌ VERSION 文件未找到${NC}"
  exit 1
fi

VERSION=$(cat "$VERSION_FILE" | tr -d ' \n\r')
if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo -e "${RED}❌ 版本格式非法: $VERSION (应为 X.Y.Z)${NC}"
  exit 1
fi

echo -e "${BLUE}🔍 版本: $VERSION${NC}"

# Git 状态检查
if [[ "$FORCE" == false ]]; then
  cd "$PROJECT_ROOT"
  if ! git diff-index --quiet HEAD --; then
    echo -e "${RED}❌ 发现未提交改动${NC}"
    exit 1
  fi
  echo -e "${GREEN}✓ Git 干净${NC}"
fi

# 验证必需文件
echo -e "${BLUE}📋 验证组件...${NC}"
REQUIRED=(
  ".claude/skills"
  ".github/skills"
  "scripts/install-skills.sh"
  "scripts/uninstall-skills.sh"
  "scripts/sync-skills.sh"
  "scripts/validate-skills.sh"
  "scripts/make-release.sh"
  "README.md"
  "CHANGELOG.md"
  "VERSION"
)

for item in "${REQUIRED[@]}"; do
  if [[ ! -e "$PROJECT_ROOT/$item" ]]; then
    echo -e "${RED}❌ 缺少: $item${NC}"
    exit 1
  fi
  echo -e "${GREEN}✓ $item${NC}"
done

# 创建 release 目录
mkdir -p "$PROJECT_ROOT/releases"
cd "$PROJECT_ROOT/releases"

RELEASE_NAME="harmonyos-skills-${VERSION}"
RELEASE_FILE="${RELEASE_NAME}.zip"

if [[ -f "$RELEASE_FILE" ]]; then
  rm -f "$RELEASE_FILE"
fi

# 临时打包目录
TEMP_DIR=$(mktemp -d)
PACKAGE_DIR="$TEMP_DIR/$RELEASE_NAME"
mkdir -p "$PACKAGE_DIR"

echo -e "${BLUE}📦 打包文件...${NC}"
cd "$PROJECT_ROOT"

# 复制主要目录和文件
cp -r .claude/skills "$PACKAGE_DIR/"
cp -r .github/skills "$PACKAGE_DIR/"
mkdir -p "$PACKAGE_DIR/scripts"
cp scripts/install-skills.sh "$PACKAGE_DIR/scripts/"
cp scripts/uninstall-skills.sh "$PACKAGE_DIR/scripts/"
cp scripts/sync-skills.sh "$PACKAGE_DIR/scripts/"
cp scripts/validate-skills.sh "$PACKAGE_DIR/scripts/"
cp scripts/make-release.sh "$PACKAGE_DIR/scripts/"
cp README.md VERSION CHANGELOG.md "$PACKAGE_DIR/"

# 可选文件
for file in LICENSE SKILLS_MANIFEST.json llms.txt INSTALL_VERIFICATION.md; do
  [[ -f "$file" ]] && cp "$file" "$PACKAGE_DIR/"
done

# 快速启动指南
cat > "$PACKAGE_DIR/QUICKSTART.md" << 'QS'
# 快速开始

## Claude 安装

```bash
bash scripts/install-skills.sh --claude
```

## Copilot 安装

```bash
bash scripts/install-skills.sh --copilot
```

详见 README.md 和 INSTALL_VERIFICATION.md。
QS

# 打包
echo -e "${BLUE}🔐 生成 SHA256...${NC}"
cd "$TEMP_DIR"
find "$RELEASE_NAME" -type f -exec shasum -a 256 {} \; > "${RELEASE_NAME}.sha256"
zip -r -q "$RELEASE_FILE" "$RELEASE_NAME" "${RELEASE_NAME}.sha256"

# 移动到发布目录
mv "$RELEASE_FILE" "$PROJECT_ROOT/releases/"
mv "${RELEASE_NAME}.sha256" "$PROJECT_ROOT/releases/"
rm -rf "$TEMP_DIR"

echo -e "${GREEN}✓ 打包完成${NC}"
echo ""
echo -e "${BLUE}📦 信息:${NC}"
FILE_SIZE=$(du -h "$PROJECT_ROOT/releases/$RELEASE_FILE" | cut -f1)
echo "  文件: $RELEASE_FILE"
echo "  大小: $FILE_SIZE"
echo "  路径: releases/$RELEASE_FILE"

# Git 标签
if [[ "$TAG_RELEASE" == true ]]; then
  TAG_NAME="v${VERSION}"
  cd "$PROJECT_ROOT"
  
  if git rev-parse "$TAG_NAME" >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠ 标签已存在: $TAG_NAME${NC}"
  else
    git tag -a "$TAG_NAME" -m "Release $VERSION"
    echo -e "${GREEN}✓ 标签已创建: $TAG_NAME${NC}"
  fi
fi

echo ""
echo -e "${GREEN}✨ 完成！${NC}"
echo ""
echo -e "${BLUE}💡 推荐使用 npx 分发（无需 zip）：${NC}"
echo "  npm version patch && git push --tags"
echo "  然后在 GitHub 创建 Release → 自动发布到 npm"
echo "  用户安装: npx harmonyos-skills-pack"
