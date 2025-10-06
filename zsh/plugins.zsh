# ~/.dotfiles/zsh/plugins/plugins.zsh
# 📦 ZSH Plugins Loader — explicit load order
# Each plugin file is sourced manually so you control initialization sequence.

DOTFILES="$HOME/dev/github.com/jeanlucaslima/dotfiles"
PLUGINS_DIR="$DOTFILES/zsh/plugins"

# 1️⃣ Core environment & PATH setup (must come first)
source "$PLUGINS_DIR/path.zsh"

# 2️⃣ Aliases & small helpers
source "$PLUGINS_DIR/aliases.zsh"

# 3️⃣ Custom functions and tools (like boil)
source "$PLUGINS_DIR/boil.zsh"

# 4️⃣ Dashboard or startup info (last, so it runs after everything is defined)
source "$PLUGINS_DIR/dashboard.zsh"
