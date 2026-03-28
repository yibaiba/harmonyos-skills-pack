#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_CLAUDE_DIR="$REPO_ROOT/.claude/skills"
SOURCE_GITHUB_DIR="$REPO_ROOT/.github/skills"

SKILLS=("harmonyos-ark" "universal-product-quality")

usage() {
  cat <<'EOF'
Usage:
  ./scripts/install-skills.sh [--claude] [--copilot-workspace <path>] [--codex <path>] [--all] [--force]

Options:
  --claude                     Install skills to ~/.claude/skills (default on if no option)
  --copilot-workspace <path>   Install skills to <path>/.github/skills
  --codex <path>               Install skills to <path>/.codex/skills
  --all                        Install to all targets (claude + copilot-workspace + codex in current dir)
  --force                      Overwrite existing target skill directories
  -h, --help                   Show help

Examples:
  ./scripts/install-skills.sh --claude
  ./scripts/install-skills.sh --copilot-workspace ~/Code/my-app
  ./scripts/install-skills.sh --codex ~/Code/my-app
  ./scripts/install-skills.sh --all --force
  ./scripts/install-skills.sh --claude --copilot-workspace ~/Code/my-app --codex ~/Code/my-app --force
EOF
}

INSTALL_CLAUDE=false
COPILOT_WORKSPACE=""
CODEX_WORKSPACE=""
FORCE=false

if [[ $# -eq 0 ]]; then
  INSTALL_CLAUDE=true
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --claude)
      INSTALL_CLAUDE=true
      shift
      ;;
    --copilot-workspace)
      if [[ $# -lt 2 ]]; then
        echo "Missing path for --copilot-workspace" >&2
        exit 1
      fi
      COPILOT_WORKSPACE="$2"
      shift 2
      ;;
    --codex)
      if [[ $# -lt 2 ]]; then
        echo "Missing path for --codex" >&2
        exit 1
      fi
      CODEX_WORKSPACE="$2"
      shift 2
      ;;
    --all)
      INSTALL_CLAUDE=true
      COPILOT_WORKSPACE="$(pwd)"
      CODEX_WORKSPACE="$(pwd)"
      shift
      ;;
    --force)
      FORCE=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

copy_skill() {
  local src="$1"
  local dst="$2"

  if [[ -e "$dst" ]]; then
    if [[ "$FORCE" == true ]]; then
      rm -rf "$dst"
    else
      echo "Skip existing: $dst (use --force to overwrite)"
      return 0
    fi
  fi

  mkdir -p "$(dirname "$dst")"
  cp -R "$src" "$dst"
  echo "Installed: $dst"
}

if [[ "$INSTALL_CLAUDE" == true ]]; then
  CLAUDE_TARGET="$HOME/.claude/skills"
  mkdir -p "$CLAUDE_TARGET"
  for skill in "${SKILLS[@]}"; do
    copy_skill "$SOURCE_CLAUDE_DIR/$skill" "$CLAUDE_TARGET/$skill"
  done
fi

if [[ -n "$COPILOT_WORKSPACE" ]]; then
  if [[ ! -d "$COPILOT_WORKSPACE" ]]; then
    echo "Workspace not found: $COPILOT_WORKSPACE" >&2
    exit 1
  fi
  COPILOT_TARGET="$COPILOT_WORKSPACE/.github/skills"
  mkdir -p "$COPILOT_TARGET"
  for skill in "${SKILLS[@]}"; do
    copy_skill "$SOURCE_GITHUB_DIR/$skill" "$COPILOT_TARGET/$skill"
  done
fi

if [[ -n "$CODEX_WORKSPACE" ]]; then
  if [[ ! -d "$CODEX_WORKSPACE" ]]; then
    echo "Workspace not found: $CODEX_WORKSPACE" >&2
    exit 1
  fi
  CODEX_TARGET="$CODEX_WORKSPACE/.codex/skills"
  mkdir -p "$CODEX_TARGET"
  for skill in "${SKILLS[@]}"; do
    copy_skill "$SOURCE_GITHUB_DIR/$skill" "$CODEX_TARGET/$skill"
  done
fi

echo "Done."
