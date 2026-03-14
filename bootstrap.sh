#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Bootstrapping macOS from $DOTFILES_DIR"

# 1. Install Homebrew
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "==> Homebrew already installed"
fi

# 2. Install Brewfile dependencies
if [ -f "$DOTFILES_DIR/Brewfile" ]; then
  echo "==> Installing Brewfile dependencies..."
  brew bundle install --file="$DOTFILES_DIR/Brewfile"
else
  echo "==> No Brewfile found, skipping brew bundle"
fi

# 3. Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "==> Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "==> Oh My Zsh already installed"
fi

# 4. Install Powerlevel10k theme
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
  echo "==> Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
  echo "==> Powerlevel10k already installed"
fi

# 5. Stow all packages
echo "==> Stowing dotfiles..."
"$DOTFILES_DIR/install.sh"

# 6. Apply macOS defaults
echo "==> Applying macOS defaults..."
"$DOTFILES_DIR/macos-defaults.sh"

# 7. SSH key reminder
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  echo ""
  echo "==> NOTE: No SSH key found at ~/.ssh/id_ed25519"
  echo "   Generate one with: ssh-keygen -t ed25519 -C \"your@email.com\""
  echo "   Then add it to GitHub: gh ssh-key add ~/.ssh/id_ed25519.pub"
fi

echo ""
echo "==> Bootstrap complete! Restart your shell or run: source ~/.zshrc"
