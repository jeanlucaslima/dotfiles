# vim:ft=zsh ts=2 sw=2 sts=2
#
# agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://gist.github.com/1595572).

export ZSH=/home/jean/.oh-my-zsh

ZSH_THEME="agnoster"

CASE_SENSITIVE="true"

export UPDATE_ZSH_DAYS=13

ENABLE_CORRECTION="true"
HIST_STAMPS="yyyy-mm-dd"

plugins=(git git-flow nvm extract rbenv docker zsh-completions zsh-syntax-highlighting)
# PS: zsh-syntax-highlitings has to be last
#
# zsh-syntax-highlighitings installation:
# https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md

# User configuration

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Zsh-autosuggestions, more here:
# https://github.com/tarruda/zsh-autosuggestions
# Load zsh-autosuggestions.
source ~/.zsh/zsh-autosuggestions/autosuggestions.zsh

# Enable autosuggestions automatically.
zle-line-init() {
    zle autosuggest-start
}

zle -N zle-line-init
# Accept suggestions without leaving insert mode
bindkey '^f' vi-forward-word

