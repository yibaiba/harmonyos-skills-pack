#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="$REPO_ROOT/skills"
CLAUDE_TARGET="$REPO_ROOT/.claude/skills"
GITHUB_TARGET="$REPO_ROOT/.github/skills"

SKILLS=("harmonyos-ark" "universal-product-quality")

copy_one() {
  local src="$1"
  local dst="$2"
  rm -rf "$dst"
  mkdir -p "$(dirname "$dst")"
  cp -R "$src" "$dst"
  echo "Synced: $dst"
}

for skill in "${SKILLS[@]}"; do
  copy_one "$SOURCE_DIR/$skill" "$CLAUDE_TARGET/$skill"
  copy_one "$SOURCE_DIR/$skill" "$GITHUB_TARGET/$skill"
done

echo "All skills synced from skills/ -> .claude/skills and .github/skills"
