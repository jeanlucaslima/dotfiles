# 🧩 ZSH Plugins Folder

This folder contains modular pieces of your shell configuration.
Instead of dumping everything into `.zshrc`, each concern is separated into a small, focused file — sourced explicitly via `plugins.zsh` in a predictable order.

---

## 📜 Files Overview

### 🛣️ `path.zsh`
Defines environment variables and sets up `$PATH`, `$FPATH`, and tool-specific initialization.
Here’s where you:

- Add or remove directories to `$PATH`
- Set global environment variables like `EDITOR`, `ERL_AFLAGS`, etc.
- Source language or runtime managers (asdf, pyenv, cargo, etc.)

**Tips**
- Always prepend new paths to `$PATH` so they take precedence.
- Use `typeset -U path fpath` (in `.zshrc`) to prevent duplicates.
- If you install new CLIs globally (e.g., `go`, `bun`, `pnpm`), add their bin paths here.

---

### ⚡️ `aliases.zsh`
All your simple aliases live here.

**Examples**
- Quick commands (`alias ll='ls -alF'`)
- Project shortcuts (`alias confra='cd ~/dev/github.com/jeanlucaslima/confraria && code .'`)
- Shortcuts for common workflows (`alias bu='brew update && brew upgrade && brew cleanup'`)

**Tips**
- Keep aliases simple. If a command needs arguments, conditionals, or logic → turn it into a function instead.
- Group them by purpose: system, dev, projects, etc.

---

### ☕️ `boil.zsh`
A helper function that updates your developer environment in one go.

**Usage**
```bash
boil                 # brew + npm
boil brew            # only brew
boil npm             # only npm
boil asdf            # list asdf tools
boil asdf upgrade    # update asdf + install missing versions
boil asdf upgrade --bump-latest  # upgrade and set latest versions globally
boil --dry-run       # preview without running
```
**Note**: `boil` checks for `brew`, `npm`, and `asdf` before running, so it’s safe even if some tools aren’t installed.

---

### 🌅 `dashboard.zsh`
A small welcome message printed on shell startup.
It shows current time, host, runtime versions, and optional extras like weather or outdated package counts.

**Customize with environment variables** (set in `.zshrc` before sourcing plugins):
```bash
export DASHBOARD_SHOW_WEATHER=1
export DASHBOARD_SHOW_STATS=1
export DASHBOARD_ASYNC=1
export DASHBOARD_CITY="Sao+Paulo"
```

**Tip**: Disable weather and stats if you want instant startup or when on low bandwidth.

---

### 🔌 `plugins.zsh`
This file defines the **explicit load order** of all the above modules.

**Example**
```zsh
DOTFILES="$HOME/dev/github.com/jeanlucaslima/dotfiles"
PLUGINS_DIR="$DOTFILES/zsh/plugins"

# 1) Core environment & PATH setup
source "$PLUGINS_DIR/path.zsh"

# 2) Aliases
source "$PLUGINS_DIR/aliases.zsh"

# 3) Custom functions (boil, etc.)
source "$PLUGINS_DIR/boil.zsh"

# 4) Startup dashboard (last)
source "$PLUGINS_DIR/dashboard.zsh"
```

**Tips**
- Control order here — e.g., `path.zsh` first so everything else sees the right `$PATH`.
- Comment out a line to temporarily disable a plugin without deleting it.

---

## 🧭 Best Practices

- **Add new tools or exports →** `path.zsh`
- **Add shortcuts or commands →** `aliases.zsh`
- **Add automation logic →** `boil.zsh` or a new `functions.zsh`
- **Add startup UI →** `dashboard.zsh`
- **Add/remove plugins →** `plugins.zsh`

---

## 📦 Keeping It Clean

- Avoid putting aliases, exports, or logic directly in `.zshrc`. That file should **only** set up plugins and high‑level configuration.
- Treat this folder like a **codebase for your shell** — review and refactor it periodically.
- If a plugin starts growing too large (>200 lines), split it into multiple files.

---

👨‍🚀 **Future You Rule**: If you’re editing something in `.zshrc` and it’s more than 2 lines long — it probably belongs in here.
