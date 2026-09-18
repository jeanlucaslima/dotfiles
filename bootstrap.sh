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
BREW_BUNDLE_FAILED=0
if [ -f "$DOTFILES_DIR/Brewfile" ]; then
  echo "==> Installing Brewfile dependencies..."
  # Don't let this abort the whole bootstrap: the Brewfile's `mas` entries
  # fail if you haven't signed into the App Store yet, which would otherwise
  # take Oh My Zsh, stow, and macOS defaults down with it (set -e).
  if ! brew bundle install --file="$DOTFILES_DIR/Brewfile"; then
    BREW_BUNDLE_FAILED=1
    echo "==> WARNING: brew bundle install reported failures (commonly Mac App"
    echo "   Store apps when you're not signed in yet — System Settings > Apple"
    echo "   ID). Sign in and re-run: brew bundle install --file=\"$DOTFILES_DIR/Brewfile\""
  fi
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

# 4. Stow all packages
echo "==> Stowing dotfiles..."
"$DOTFILES_DIR/install.sh"

# 5. Apply macOS defaults
echo "==> Applying macOS defaults..."
"$DOTFILES_DIR/macos-defaults.sh"

# 6. SSH signing key reminder
# git/.gitconfig (just stowed) turns on commit/tag signing via 1Password's SSH
# agent (see ssh/.ssh/config's IdentityAgent). It expects the public half of
# your key at ~/.ssh/id_ed25519.pub, matching the fingerprint in
# git/.config/git/allowed_signers — a freshly `ssh-keygen`'d key won't match.
if [ ! -f "$HOME/.ssh/id_ed25519.pub" ]; then
  echo ""
  echo "==> NOTE: git commit/tag signing is enabled but no key found at"
  echo "   ~/.ssh/id_ed25519.pub. This identity is managed by 1Password:"
  echo "     1. Open 1Password > Settings > Developer > enable 'Use the SSH Agent'"
  echo "     2. Confirm your ed25519 key is in the vault (or create one there)"
  echo "     3. Save its public key text to ~/.ssh/id_ed25519.pub"
  echo "     4. Add it to GitHub as both key types:"
  echo "          gh ssh-key add ~/.ssh/id_ed25519.pub --type authentication"
  echo "          gh ssh-key add ~/.ssh/id_ed25519.pub --type signing"
  echo "   Until then, git commit/tag will fail to sign."
fi

echo ""
if [ "$BREW_BUNDLE_FAILED" -eq 1 ]; then
  echo "==> Bootstrap finished with warnings — see the brew bundle notice above."
else
  echo "==> Bootstrap complete!"
fi
echo "   Restart your shell or run: source ~/.zshrc"
