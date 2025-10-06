# ~/dev/github.com/jeanlucaslima/dotfiles/zsh/plugins/path.zsh
# 🛣️ Environment Variables & PATH Setup
# -------------------------------------------------------------------
# This file is sourced early in your zsh load sequence (before aliases/functions).
# It centralizes all environment variables and PATH setup in one place.

# ── 📦 General Environment ─────────────────────────────────────────────
export EDITOR="nvim"
export HOMEBREW_NO_ENV_HINTS=1

# Enable shell history for iex (Elixir)
export ERL_AFLAGS="-kernel shell_history enabled"

# ── 📁 Tool Locations ──────────────────────────────────────────────────
# ASDF (Version Manager)
export ASDF_DIR="$HOME/.asdf"
[ -f "$ASDF_DIR/asdf.sh" ] && . "$ASDF_DIR/asdf.sh"

# Pyenv (Python version manager)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Deno
export DENO_INSTALL="$HOME/.deno"

# Cargo (Rust) environment
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# ── 🌐 PATH Customization ──────────────────────────────────────────────
# Prepend important tool paths so they take precedence
export PATH="$ASDF_DIR/shims:$ASDF_DIR/bin:$PATH"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$DENO_INSTALL/bin:$PATH"

# Brew (binaries and autocompletion)
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# Core system binaries and utilities
export PATH="/usr/local/opt/bzip2/bin:$PATH"
export PATH="/usr/local/opt/curl/bin:$PATH"
export PATH="/usr/local/opt/sqlite/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/etc/paths.d/postgresapp:$PATH"

# Windsurf CLI (Codeium)
export PATH="$HOME/.codeium/windsurf/bin:$PATH"

# ── 🔁 Optional Sourcing ───────────────────────────────────────────────
# fzf (fuzzy finder)
[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"

# Bash profile (only if you rely on legacy exports there)
[ -f "$HOME/.bash_profile" ] && source "$HOME/.bash_profile"
