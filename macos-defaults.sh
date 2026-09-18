#!/usr/bin/env bash
set -euo pipefail

echo "Applying macOS defaults..."

# Dock — left side, small icons, magnified on hover
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock orientation -string left
defaults write com.apple.dock tilesize -int 29
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 94

# Keyboard — fast repeat
defaults write NSGlobalDomain KeyRepeat -int 12
defaults write NSGlobalDomain InitialKeyRepeat -int 68

# Appearance
defaults write NSGlobalDomain AppleInterfaceStyle -string Dark

# Mouse & trackpad — max tracking speed, tap-to-click, two-finger right-click
defaults write NSGlobalDomain com.apple.mouse.scaling -float 3
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 3
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true

# Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv
defaults write com.apple.finder FXDefaultSearchScope -string SCcf
defaults write com.apple.finder NewWindowTarget -string PfAF

# Menu bar clock — day of week, no full date
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true
defaults write com.apple.menuextra.clock ShowDate -bool false

# Screenshots to ~/Documents
defaults write com.apple.screencapture location -string "${HOME}/Documents"

# Restart affected apps
killall Dock Finder SystemUIServer

echo "macOS defaults applied."
