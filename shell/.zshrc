# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

plugins=(git mix brew)

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'
export VISUAL='nvim'

autoload -U compinit
compinit

eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
### --- Completions & Plugins (post-OMZ) ---
# Make sure Homebrew is first in PATH (Apple Silicon)
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# Use Homebrew curl instead of macOS system curl
export PATH="/opt/homebrew/opt/curl/bin:$PATH"

# Autosuggestions (type-ahead, accept with →)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'     # subtle gray

# fzf completion & keybindings (Ctrl-R popup)
[ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" ] && source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
[ -f "$(brew --prefix)/opt/fzf/shell/completion.zsh" ] && source "$(brew --prefix)/opt/fzf/shell/completion.zsh"

# Make fzf appear as a small popup at the bottom
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --info=inline'
# Optional: tweak the Ctrl-R history view
export FZF_CTRL_R_OPTS='--exact --keep-right --no-mouse --preview-window=down,3,wrap --bind=ctrl-y:accept'

# Starship prompt
eval "$(starship init zsh)"

# Transient prompt — collapse previous prompts to ❯
zle-line-init() {
  emulate -L zsh
  [[ $CONTEXT == start ]] || return 0

  while true; do
    zle .recursive-edit
    local -i ret=$?
    [[ $ret == 0 && $KEYS == $'\4' ]] || break
    [[ -o ignore_eof ]] || exit 0
  done

  local saved_prompt=$PROMPT
  local saved_rprompt=$RPROMPT
  PROMPT='%F{green}❯%f '
  RPROMPT=''
  zle .reset-prompt
  PROMPT=$saved_prompt
  RPROMPT=$saved_rprompt

  if (( ret )); then
    zle .send-break
  else
    zle .accept-line
  fi
  return ret
}
zle -N zle-line-init

# Syntax highlighting should be last
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Smarter completion behavior
setopt AUTO_LIST AUTO_MENU COMPLETE_IN_WORD
bindkey '^I' expand-or-complete         # Tab completes
# Arrow up/down search history by prefix:
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# Use fd for fzf file finding
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

export ERL_AFLAGS="-kernel shell_history enabled"

. "$HOME/.local/bin/env"

# Added by Antigravity
export PATH="/Users/jeanlucaslima/.antigravity/antigravity/bin:$PATH"

# Aliases
alias cat="bat --paging=never"
alias catp="bat"
alias list="eza --icons -l --git"
alias la="eza --icons -la --git"
alias lt="eza --icons -l --git --tree --level=2"

# Navigation
alias ..="cd .."
alias ...="cd ../.."

# Git shortcuts
alias g="git"
alias gs="git status -sb"
alias gd="git diff"
alias gl="git log --oneline --graph --decorate -20"
alias gp="git push"
alias gpl="git pull"

# Quick config editing
alias zshrc="$EDITOR ~/.zshrc"

# Homebrew maintenance in one shot
bruh() {
  local outdated_before cask_before mas_before

  echo "\n🍺 Updating Homebrew..."
  brew update

  outdated_before=$(brew outdated --quiet | wc -l | tr -d ' ')
  echo "\n📦 Upgrading $outdated_before outdated formulae..."
  brew upgrade

  cask_before=$(brew outdated --cask --quiet | wc -l | tr -d ' ')
  echo "\n🖥  Upgrading $cask_before outdated casks..."
  brew upgrade --cask

  mas_before=$(mas outdated | wc -l | tr -d ' ')
  echo "\n🍎 Upgrading $mas_before App Store apps..."
  mas upgrade

  echo "\n🧹 Removing unused dependencies..."
  brew autoremove

  echo "\n🧼 Cleaning up old downloads..."
  brew cleanup -s

  echo "\n🩺 Running brew doctor..."
  brew doctor 2>&1

  echo "\n✅ Done — upgraded $outdated_before formulae, $cask_before casks, $mas_before App Store apps."
}

# bun completions
[ -s "/Users/jeanlucaslima/.bun/_bun" ] && source "/Users/jeanlucaslima/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
