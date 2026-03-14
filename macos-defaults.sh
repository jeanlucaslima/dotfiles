#!/usr/bin/env bash
set -euo pipefail

echo "Applying macOS defaults..."

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 49

# Keyboard — fast repeat
defaults write NSGlobalDomain KeyRepeat -int 12
defaults write NSGlobalDomain InitialKeyRepeat -int 68

# Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true

# Screenshots to ~/Documents
defaults write com.apple.screencapture location -string "${HOME}/Documents"

# Restart affected apps
killall Dock Finder

echo "macOS defaults applied."
