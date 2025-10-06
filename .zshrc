# ─────────────────────────────────────────────────────────────────────────────
# Brew autocompletion setup (must be before oh-my-zsh)
# (Guarded so it won't error on systems without Homebrew)
if command -v brew >/dev/null 2>&1; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# De-duplicate path arrays (keeps first occurrence; prevents PATH bloat)
typeset -U path fpath

export ASDF_DIR="$HOME/.asdf"
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

# Order: autosuggestions BEFORE syntax-highlighting; highlighting LAST
plugins=(git tmux genpass zsh-autosuggestions zsh-syntax-highlighting)

source "$ZSH/oh-my-zsh.sh"

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Enable shell history for iex
export ERL_AFLAGS="-kernel shell_history enabled"

# Only if you still rely on legacy exports there
# [[ -f ~/.bash_profile ]] && source ~/.bash_profile

# ── pyenv (single, non-duplicated) ───────────────────────────────────────────
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Optional tooling
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/bzip2/bin:$PATH"
export PATH="/usr/local/opt/curl/bin:$PATH"
export PATH="/usr/local/opt/sqlite/bin:$PATH"
# NOTE: /etc/paths.d is not a bin dir; don't add it directly to PATH.

export HOMEBREW_NO_ENV_HINTS=1
export EDITOR="nvim"

# ── asdf init + completions (guarded) ────────────────────────────────────────
if [[ -f "$ASDF_DIR/asdf.sh" ]]; then
  . "$ASDF_DIR/asdf.sh"
  # Add asdf completion functions; compinit is already run by oh-my-zsh
  if [[ -d "$ASDF_DIR/completions" ]]; then
    fpath=("$ASDF_DIR/completions" $fpath)
  fi
fi

# ✅ Aliases have been moved to zsh/plugins/aliases.zsh
# Add new aliases there instead of here.

# Deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# Windsurf
export PATH="$HOME/.codeium/windsurf/bin:$PATH"

# Rust (guarded)
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# ── Custom plugins loader (explicit order lives in plugins.zsh) ──────────────
export DOTFILES="$HOME/dev/github.com/jeanlucaslima/dotfiles"

# Dashboard knobs (optional)
export DASHBOARD_SHOW_WEATHER=1
export DASHBOARD_SHOW_STATS=1
export DASHBOARD_CITY="Sao+Paulo"

if [ -f "$DOTFILES/zsh/plugins.zsh" ]; then
  source "$DOTFILES/zsh/plugins.zsh"
fi
