#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
PACKAGES=(shell git nvim zed ghostty mise starship fish ssh tmux)

echo "Stowing dotfiles from $DOTFILES_DIR to $HOME"

for pkg in "${PACKAGES[@]}"; do
  echo "  stow $pkg"
  stow -t "$HOME" -d "$DOTFILES_DIR" "$pkg"
done

echo "Done. Restart your shell or run: source ~/.zshrc"
