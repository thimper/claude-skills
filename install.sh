#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_NAME="$(basename "$SCRIPT_DIR")"
SKILLS_BASE="$HOME/claude-skills"
ZSHRC="$HOME/.zshrc"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

WRAPPER_MARKER="# claude-skills: auto-add-dir wrapper"

WRAPPER_FUNC="${WRAPPER_MARKER}
claude() {
  local dirs=()
  for repo in ~/claude-skills/*/; do
    dirs+=(--add-dir \"\$repo\")
  done
  command claude \"\${dirs[@]}\" \"\$@\"
}"

usage() {
  echo "Usage: $0 [--uninstall]"
  echo
  echo "Install:    Clone repo into ~/claude-skills/ and add claude wrapper to ~/.zshrc"
  echo "Uninstall:  Remove repo and claude wrapper from ~/.zshrc"
}

has_wrapper() {
  grep -qF "$WRAPPER_MARKER" "$ZSHRC" 2>/dev/null
}

install() {
  # Step 1: Ensure repo is under ~/claude-skills/
  if [[ "$SCRIPT_DIR" != "$SKILLS_BASE"/* ]]; then
    echo -e "${YELLOW}This repo is not under ~/claude-skills/.${NC}"
    echo -e "Symlinking: ${GREEN}$SKILLS_BASE/$REPO_NAME${NC} -> $SCRIPT_DIR"
    mkdir -p "$SKILLS_BASE"
    if [ -L "$SKILLS_BASE/$REPO_NAME" ] || [ -e "$SKILLS_BASE/$REPO_NAME" ]; then
      echo -e "  ${YELLOW}skip${NC} $SKILLS_BASE/$REPO_NAME already exists"
    else
      ln -s "$SCRIPT_DIR" "$SKILLS_BASE/$REPO_NAME"
      echo -e "  ${GREEN}linked${NC} $SKILLS_BASE/$REPO_NAME"
    fi
  else
    echo -e "Repo already under ~/claude-skills/: ${GREEN}$SCRIPT_DIR${NC}"
  fi

  # Step 2: Add wrapper function to .zshrc
  if has_wrapper; then
    echo -e "${YELLOW}claude wrapper already in ~/.zshrc, skipping.${NC}"
  else
    echo "" >> "$ZSHRC"
    echo "$WRAPPER_FUNC" >> "$ZSHRC"
    echo -e "${GREEN}Added claude wrapper function to ~/.zshrc${NC}"
  fi

  echo
  echo -e "${GREEN}Done!${NC} Run ${YELLOW}source ~/.zshrc${NC} or open a new terminal to activate."
  echo "All skill repos under ~/claude-skills/ will be auto-loaded by Claude Code."
}

uninstall() {
  # Step 1: Remove repo symlink from ~/claude-skills/ (only if it's a symlink)
  local target="$SKILLS_BASE/$REPO_NAME"
  if [ -L "$target" ]; then
    rm "$target"
    echo -e "${RED}Removed${NC} symlink $target"
  elif [ -d "$target" ] && [ "$target" = "$SCRIPT_DIR" ]; then
    echo -e "${YELLOW}Repo is directly in ~/claude-skills/, not removing directory.${NC}"
    echo -e "Remove manually: rm -rf $target"
  fi

  # Step 2: Remove wrapper function from .zshrc
  if has_wrapper; then
    # Remove the marker line and the function block
    local tmp
    tmp=$(mktemp)
    awk -v marker="$WRAPPER_MARKER" '
      $0 == marker { skip=1; next }
      skip && /^claude\(\)/ { next }
      skip && /^\{/ { next }
      skip && /^\}/ { skip=0; next }
      skip { next }
      { print }
    ' "$ZSHRC" > "$tmp"
    # Remove trailing blank lines left behind
    sed -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$tmp" > "$ZSHRC"
    rm "$tmp"
    echo -e "${RED}Removed${NC} claude wrapper from ~/.zshrc"
  else
    echo -e "${YELLOW}No claude wrapper found in ~/.zshrc${NC}"
  fi

  echo -e "${GREEN}Done!${NC} Run ${YELLOW}source ~/.zshrc${NC} or open a new terminal."
}

case "${1:-}" in
  --uninstall)
    uninstall
    ;;
  --help|-h)
    usage
    ;;
  "")
    install
    ;;
  *)
    echo -e "${RED}Unknown option: $1${NC}"
    usage
    exit 1
    ;;
esac
