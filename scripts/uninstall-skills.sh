#!/usr/bin/env bash
set -euo pipefail

SKILLS=("harmonyos-ark" "universal-product-quality")

usage() {
  cat <<'EOF'
Usage:
  ./scripts/uninstall-skills.sh [--claude] [--copilot-workspace <path>]

Options:
  --claude                     Uninstall from ~/.claude/skills (default on if no option)
  --copilot-workspace <path>   Uninstall from <path>/.github/skills
  -h, --help                   Show help

Examples:
  ./scripts/uninstall-skills.sh --claude
  ./scripts/uninstall-skills.sh --copilot-workspace ~/Code/my-app
EOF
}

UNINSTALL_CLAUDE=false
COPILOT_WORKSPACE=""

if [[ $# -eq 0 ]]; then
  UNINSTALL_CLAUDE=true
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --claude)
      UNINSTALL_CLAUDE=true
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

remove_if_exists() {
  local p="$1"
  if [[ -e "$p" ]]; then
    rm -rf "$p"
    echo "Removed: $p"
  else
    echo "Not found: $p"
  fi
}

if [[ "$UNINSTALL_CLAUDE" == true ]]; then
  for skill in "${SKILLS[@]}"; do
    remove_if_exists "$HOME/.claude/skills/$skill"
  done
fi

if [[ -n "$COPILOT_WORKSPACE" ]]; then
  for skill in "${SKILLS[@]}"; do
    remove_if_exists "$COPILOT_WORKSPACE/.github/skills/$skill"
  done
fi

echo "Done."
