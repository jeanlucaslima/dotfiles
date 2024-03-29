# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

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

export HOMEBREW_NO_ENV_HINTS=1
