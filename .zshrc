# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Brew autocompletion setup (has to be before oh-my-zsh)
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

export ASDF_DIR="/Users/jeanlucaslima/.asdf"

export ZSH="/Users/jeanlucaslima/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git tmux zsh-autosuggestions zsh-syntax-highlighting genpass)

source $ZSH/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Enable shell history for iex
export ERL_AFLAGS="-kernel shell_history enabled"

source ~/.bash_profile

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="/usr/local/opt/bzip2/bin:$PATH"

eval "$(pyenv init -)"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/usr/local/sbin:$PATH"

# curl
export PATH="/usr/local/opt/curl/bin:$PATH"
export PATH="/usr/local/opt/sqlite/bin:$PATH"

# Adding paths.d to $PATH mainly because of Postgres.App
export PATH="/etc/paths.d/postgresapp:$PATH"

alias tmux="tmux -u"
alias confra="cd ~/dev/github.com/jeanlucaslima/confraria/; code .; mix phx.server"
alias bu="brew update; brew upgrade; brew cleanup"

# elixir / phoenix related aliases
alias mcc="mix clean; mix compile"
alias ms="mix phx.server"

alias getip="dig @ns1.google.com TXT o-o.myaddr.l.google.com +short"

export HOMEBREW_NO_ENV_HINTS=1
export EDITOR="nvim"

# asdf 
. "$HOME/.asdf/asdf.sh"

export DENO_INSTALL="/Users/jeanlucaslima/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# Added by Windsurf
export PATH="/Users/jeanlucaslima/.codeium/windsurf/bin:$PATH"
