# ~/dev/github.com/jeanlucaslima/dotfiles/zsh/plugins/aliases.zsh
# ⚡️ Common Aliases & Shortcuts
# -------------------------------------------------------------------
# These are frequently used commands, project shortcuts, and quality-of-life helpers.
# Keep them organized by category for clarity.

# ── 🧰 General Utilities ──────────────────────────────────────────────
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Show your public IP
alias getip="dig @ns1.google.com TXT o-o.myaddr.l.google.com +short"

# ── 🧪 Development Shortcuts ───────────────────────────────────────────
# Elixir / Phoenix helpers
alias mcc="mix clean && mix compile"
alias ms="mix phx.server"

# Shortcut to open and run your Confraria project
alias confra="cd ~/dev/github.com/jeanlucaslima/confraria && code . && mix phx.server"

# ── 🍺 Package Updaters ────────────────────────────────────────────────
# Homebrew quick update
alias bu="brew update && brew upgrade && brew cleanup"

# (optional) npm quick update (if you still want it)
alias nu="npm install -g npm && npm outdated -g --parseable --depth=0 | cut -d: -f4 | xargs npm install -g"

# ── 🛠️ System Shortcuts ────────────────────────────────────────────────
# Ensure tmux runs with UTF-8 support
alias tmux="tmux -u"

# (Optional) Quick reload of Zsh config
alias reload="source ~/.zshrc && echo '✅ Zsh reloaded.'"

# ── 📁 Navigation ──────────────────────────────────────────────────────
# Jump to common directories (feel free to add more)
alias dots="cd ~/dev/github.com/jeanlucaslima/dotfiles"
alias dev="cd ~/dev"
