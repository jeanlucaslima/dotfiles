# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

plugins=(mix)

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'
export VISUAL='nvim'

# NOTE: do not run compinit here. oh-my-zsh already runs it above with a
# host+version-keyed dump that self-heals on zsh upgrades or fpath changes
# (see oh-my-zsh.sh). A second bare `compinit` writes a non-versioned
# ~/.zcompdump that goes stale across zsh upgrades, which is what caused the
# intermittent `_main_complete: function definition file not found` errors.

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
# Use the hardcoded Homebrew prefix (matches the rest of this file) instead of
# forking `brew --prefix` — brew is a Ruby script and each call costs ~30ms.
[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ] && source /opt/homebrew/opt/fzf/shell/completion.zsh

# Make fzf appear as a small popup at the bottom
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --info=inline'
# Optional: tweak the Ctrl-R history view
export FZF_CTRL_R_OPTS='--exact --keep-right --no-mouse --preview-window=down,3,wrap --bind=ctrl-y:accept'

# Starship prompt
eval "$(starship init zsh)"

# Transient prompt — collapse previous prompts to ❯
[ -f /opt/homebrew/share/zsh-transient-prompt/transient-prompt.zsh-theme ] && \
  source /opt/homebrew/share/zsh-transient-prompt/transient-prompt.zsh-theme && \
  TRANSIENT_PROMPT_TRANSIENT_PROMPT="$(starship module character)"

# Syntax highlighting should be last
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Smarter completion behavior
setopt AUTO_LIST AUTO_MENU COMPLETE_IN_WORD
bindkey '^I' expand-or-complete         # Tab completes
# Arrow up/down search history by prefix. Bind BOTH the normal (^[[A) and
# application-cursor-mode (^[OA) sequences — terminals flip zle into app mode
# during line editing, so the up arrow often sends ^[OA. Binding only ^[[A left
# ^[OA on OMZ's default up-line-or-beginning-search, which autosuggest wraps and
# whose autoload file vanishes after a zsh upgrade (intermittent "function
# definition file not found"). terminfo covers whatever this terminal actually sends.
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey '^[OA' up-line-or-search
bindkey '^[OB' down-line-or-search
[[ -n "${terminfo[kcuu1]}" ]] && bindkey "${terminfo[kcuu1]}" up-line-or-search
[[ -n "${terminfo[kcud1]}" ]] && bindkey "${terminfo[kcud1]}" down-line-or-search

# Use fd for fzf file finding
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

export ERL_AFLAGS="-kernel shell_history enabled"

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

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

# AI CLIs
alias c="claude"
alias o="codex"

# Quick config editing
alias zshrc="$EDITOR ~/.zshrc"

# Homebrew maintenance in one shot
bruh() {
  local all_steps=(brew mas mise npm bun pnpm yarn rustup pipx pip gem composer gcloud nix tldr macos cleanup)
  local BRUH_DISABLED=()
  local BRUH_PROMPT_DISABLE=true
  local BRUH_PROMPT_ENABLE=true
  local config_file="${XDG_CONFIG_HOME:-$HOME/.config}/bruh/config"
  if [ -r "$config_file" ]; then
    local line key value
    while IFS= read -r line || [ -n "$line" ]; do
      line="${line%%#*}"
      [[ "$line" != *"="* ]] && continue
      key="${line%%=*}"
      value="${line#*=}"
      key="${key// /}"
      value="${value## }"
      value="${value%% }"
      case "$key" in
        disabled)
          [ -n "$value" ] && BRUH_DISABLED=(${=value}) ;;
        prompt_disable)
          BRUH_PROMPT_DISABLE="$value" ;;
        prompt_enable)
          BRUH_PROMPT_ENABLE="$value" ;;
        "") ;;
        *) echo "⚠️  bruh config: unknown key '$key' in $config_file" ;;
      esac
    done < "$config_file"
  fi

  # Map a step name to the binary that proves it's installed.
  _bruh_step_cmd() {
    case "$1" in
      nix) echo nix-channel ;;
      macos|cleanup|brew) echo brew ;;
      *) echo "$1" ;;
    esac
  }

  _bruh_upsert_key() {
    local key="$1" val="$2" file="$3"
    mkdir -p "$(dirname "$file")"
    [ ! -f "$file" ] && touch "$file"
    if grep -q "^[[:space:]]*${key}[[:space:]]*=" "$file"; then
      local tmp
      tmp=$(mktemp)
      sed "s|^[[:space:]]*${key}[[:space:]]*=.*|${key} = ${val}|" "$file" > "$tmp" && mv "$tmp" "$file"
    else
      printf '%s = %s\n' "$key" "$val" >> "$file"
    fi
  }

  # If a disabled step now has its tool installed, offer to re-enable it.
  if [ ${#BRUH_DISABLED[@]} -gt 0 ] && [ -t 0 ] && [[ "$BRUH_PROMPT_ENABLE" != "false" ]]; then
    local -a now_installed
    local d cmd
    for d in "${BRUH_DISABLED[@]}"; do
      cmd=$(_bruh_step_cmd "$d")
      command -v "$cmd" &>/dev/null && now_installed+=("$d")
    done
    if [ ${#now_installed[@]} -gt 0 ]; then
      echo "💡 These disabled tools are now installed: ${now_installed[*]}"
      echo "   Re-enable them in bruh's default run?"
      echo "   [y]es  [n]o  [s]top asking (sets prompt_enable = false)"
      printf "   > "
      local reply
      read -r reply
      case "${reply:l}" in
        y|yes)
          local -a kept
          for d in "${BRUH_DISABLED[@]}"; do
            [[ ! " ${now_installed[*]} " == *" $d "* ]] && kept+=("$d")
          done
          BRUH_DISABLED=("${kept[@]}")
          _bruh_upsert_key disabled "${BRUH_DISABLED[*]}" "$config_file"
          echo "   ✓ Re-enabled: ${now_installed[*]}"
          ;;
        s|stop|never)
          _bruh_upsert_key prompt_enable false "$config_file"
          echo "   ✓ Won't ask again (prompt_enable = false in $config_file)"
          ;;
        *)
          echo "   skipped"
          ;;
      esac
      echo
    fi
  fi

  local DRY=0
  local args=()
  local a
  for a in "$@"; do
    case "$a" in
      -h|--help)
        echo "Usage: bruh [--dry-run] [step ...]"
        echo "  Run with no args (and no flags) to update everything."
        echo "  --dry-run  Show what would run without executing."
        echo "  Available steps: ${all_steps[*]}"
        return 0
        ;;
      -n|--dry-run) DRY=1 ;;
      *) args+=("$a") ;;
    esac
  done

  local steps step s
  if [ ${#args[@]} -eq 0 ]; then
    steps=()
    for step in "${all_steps[@]}"; do
      if [[ ! " ${BRUH_DISABLED[*]} " == *" $step "* ]]; then
        steps+=("$step")
      fi
    done
  else
    steps=("${args[@]}")
    for s in "${steps[@]}"; do
      if [[ ! " ${all_steps[*]} " == *" $s "* ]]; then
        echo "❌ Unknown step: $s"
        echo "   Available: ${all_steps[*]}"
        return 1
      fi
    done
  fi

  _bruh_has() { [[ " ${steps[*]} " == *" $1 "* ]]; }
  _bruh_run() {
    if [ $DRY -eq 1 ]; then
      echo "   [dry-run] would run: $*"
      return 0
    else
      "$@"
    fi
  }

  typeset -A BRUH_STATUS
  local BRUH_NOTES=()
  local _bruh_t0=$(date +%s)
  _bruh_set() {
    if [ $DRY -eq 1 ] && [[ "$2" == ok* ]]; then
      BRUH_STATUS[$1]="would update${2#ok}"
    else
      BRUH_STATUS[$1]="$2"
    fi
  }
  _bruh_note() { BRUH_NOTES+=("$1"); }

  local outdated_before=0 cask_before=0 mas_before=0 npm_before=0 bun_before=0

  local rc=0

  if _bruh_has brew; then
    echo "\n🍺 Updating Homebrew..."
    _bruh_run brew update; rc=$?
    outdated_before=$(brew outdated --quiet | wc -l | tr -d ' ')
    echo "\n📦 Upgrading $outdated_before outdated formulae..."
    _bruh_run brew upgrade; (( rc |= $? ))
    cask_before=$(brew outdated --cask --quiet | wc -l | tr -d ' ')
    echo "\n🖥  Upgrading $cask_before outdated casks..."
    _bruh_run brew upgrade --cask; (( rc |= $? ))
    if [ $rc -eq 0 ]; then
      _bruh_set brew "ok ($outdated_before formulae, $cask_before casks)"
    else
      _bruh_set brew "failed"
    fi
  fi

  if _bruh_has mas; then
    if command -v mas &>/dev/null; then
      mas_before=$(mas outdated | wc -l | tr -d ' ')
      echo "\n🍎 Upgrading $mas_before App Store apps..."
      if _bruh_run mas upgrade; then
        _bruh_set mas "ok ($mas_before apps)"
      else
        _bruh_set mas "failed"
      fi
    else
      echo "\n🍎 Skipping App Store apps (mas not installed — run: brew install mas)"
      _bruh_set mas "not installed"
    fi
  fi

  if _bruh_has mise; then
    if command -v mise &>/dev/null; then
      echo "\n🧰 Updating mise-managed tools (global)..."
      if [ $DRY -eq 1 ]; then
        echo "   [dry-run] would run: (cd \$HOME && mise install && mise upgrade)"
        _bruh_set mise "dry-run"
      elif (cd "$HOME" && mise install && mise upgrade); then
        _bruh_set mise "ok"
      else
        _bruh_set mise "failed"
      fi
    else
      echo "\n🧰 Skipping mise (not installed)"
      _bruh_set mise "not installed"
    fi
  fi

  if _bruh_has npm; then
    if command -v npm &>/dev/null; then
      local npm_global_count
      npm_global_count=$(npm ls -g --depth=0 --parseable 2>/dev/null | tail -n +2 | grep -c .)
      if [ "$npm_global_count" -gt 0 ]; then
        npm_before=$(npm outdated -g --parseable 2>/dev/null | grep -c . | tr -d ' ')
        echo "\n📦 Upgrading $npm_before outdated global npm packages..."
        if _bruh_run npm update -g; then
          _bruh_set npm "ok ($npm_before packages)"
        else
          _bruh_set npm "failed"
        fi
      else
        echo "\n📦 Skipping npm (no global packages installed)"
        _bruh_set npm "no globals"
      fi
    else
      echo "\n📦 Skipping npm (not installed)"
      _bruh_set npm "not installed"
    fi
  fi

  if _bruh_has bun; then
    if command -v bun &>/dev/null; then
      local bun_global_count
      bun_global_count=$(bun pm ls -g 2>/dev/null | tail -n +2 | grep -c .)
      if [ "$bun_global_count" -gt 0 ]; then
        bun_before=$bun_global_count
        echo "\n🥟 Upgrading $bun_before global bun packages..."
        if _bruh_run bun update -g; then
          _bruh_set bun "ok ($bun_before packages)"
        else
          _bruh_set bun "failed"
        fi
      else
        echo "\n🥟 Skipping bun (no global packages installed)"
        _bruh_set bun "no globals"
      fi
    else
      echo "\n🥟 Skipping bun (not installed)"
      _bruh_set bun "not installed"
    fi
  fi

  if _bruh_has pnpm; then
    if command -v pnpm &>/dev/null; then
      local pnpm_global_count
      pnpm_global_count=$(pnpm ls -g --depth=0 --parseable 2>/dev/null | tail -n +2 | grep -c .)
      if [ "$pnpm_global_count" -gt 0 ]; then
        echo "\n📦 Upgrading $pnpm_global_count global pnpm packages..."
        if _bruh_run pnpm update -g; then
          _bruh_set pnpm "ok ($pnpm_global_count packages)"
        else
          _bruh_set pnpm "failed"
        fi
      else
        echo "\n📦 Skipping pnpm (no global packages installed)"
        _bruh_set pnpm "no globals"
      fi
    else
      echo "\n📦 Skipping pnpm (not installed)"
      _bruh_set pnpm "not installed"
    fi
  fi

  if _bruh_has yarn; then
    if command -v yarn &>/dev/null; then
      echo "\n🧶 Upgrading global yarn packages..."
      if [ $DRY -eq 1 ]; then
        echo "   [dry-run] would run: yarn global upgrade"
        _bruh_set yarn "dry-run"
      elif yarn global upgrade 2>/dev/null; then
        _bruh_set yarn "ok"
      else
        echo "   (no global yarn packages or upgrade failed)"
        _bruh_set yarn "no globals or failed"
      fi
    else
      echo "\n🧶 Skipping yarn (not installed)"
      _bruh_set yarn "not installed"
    fi
  fi

  if _bruh_has rustup; then
    if command -v rustup &>/dev/null; then
      echo "\n🦀 Updating rustup toolchains..."
      rc=0
      _bruh_run rustup update; rc=$?
      if command -v cargo-install-update &>/dev/null; then
        echo "\n🦀 Upgrading cargo-installed crates..."
        _bruh_run cargo install-update -a; (( rc |= $? ))
      fi
      [ $rc -eq 0 ] && _bruh_set rustup "ok" || _bruh_set rustup "failed"
    else
      echo "\n🦀 Skipping rustup (not installed)"
      _bruh_set rustup "not installed"
    fi
  fi

  if _bruh_has pipx; then
    if command -v pipx &>/dev/null; then
      echo "\n🐍 Upgrading pipx packages..."
      if _bruh_run pipx upgrade-all; then
        _bruh_set pipx "ok"
      else
        _bruh_set pipx "failed"
      fi
    else
      echo "\n🐍 Skipping pipx (not installed)"
      _bruh_set pipx "not installed"
    fi
  fi

  if _bruh_has pip; then
    local pip_cmd=""
    if command -v pip3 &>/dev/null; then
      pip_cmd=pip3
    elif command -v pip &>/dev/null; then
      pip_cmd=pip
    fi
    if [ -n "$pip_cmd" ]; then
      local pip_outdated_list pip_outdated_count pip_pkgs
      pip_outdated_list=$($pip_cmd list --user --outdated --format=freeze 2>/dev/null)
      pip_outdated_count=$(echo "$pip_outdated_list" | grep -c .)
      if [ "$pip_outdated_count" -gt 0 ]; then
        pip_pkgs=$(echo "$pip_outdated_list" | cut -d= -f1 | tr '\n' ' ')
        echo "\n🐍 Upgrading $pip_outdated_count outdated --user pip packages..."
        if _bruh_run $pip_cmd install --user --upgrade ${=pip_pkgs}; then
          _bruh_set pip "ok ($pip_outdated_count packages)"
        else
          _bruh_set pip "failed"
        fi
      else
        echo "\n🐍 Skipping pip (no outdated --user packages)"
        _bruh_set pip "no outdated"
      fi
    else
      echo "\n🐍 Skipping pip (not installed)"
      _bruh_set pip "not installed"
    fi
  fi

  if _bruh_has gem; then
    if command -v gem &>/dev/null; then
      echo "\n💎 Updating gem and installed gems..."
      if [ $DRY -eq 1 ]; then
        echo "   [dry-run] would run: gem update --system --silent && gem update --silent"
        _bruh_set gem "dry-run"
      elif gem update --system --silent && gem update --silent; then
        _bruh_set gem "ok"
      else
        _bruh_set gem "failed"
      fi
    else
      echo "\n💎 Skipping gem (not installed)"
      _bruh_set gem "not installed"
    fi
  fi

  if _bruh_has composer; then
    if command -v composer &>/dev/null; then
      echo "\n🎼 Upgrading global composer packages..."
      if _bruh_run composer global update; then
        _bruh_set composer "ok"
      else
        _bruh_set composer "failed"
      fi
    else
      echo "\n🎼 Skipping composer (not installed)"
      _bruh_set composer "not installed"
    fi
  fi

  if _bruh_has gcloud; then
    if command -v gcloud &>/dev/null; then
      echo "\n☁️  Updating gcloud components..."
      if _bruh_run gcloud components update --quiet; then
        _bruh_set gcloud "ok"
      else
        _bruh_set gcloud "failed"
      fi
    else
      echo "\n☁️  Skipping gcloud (not installed)"
      _bruh_set gcloud "not installed"
    fi
  fi

  if _bruh_has nix; then
    if command -v nix-channel &>/dev/null; then
      echo "\n❄️  Updating nix channels..."
      if [ $DRY -eq 1 ]; then
        echo "   [dry-run] would run: nix-channel --update && nix-env -u"
        _bruh_set nix "dry-run"
      elif nix-channel --update && nix-env -u; then
        _bruh_set nix "ok"
      else
        _bruh_set nix "failed"
      fi
    else
      echo "\n❄️  Skipping nix (not installed)"
      _bruh_set nix "not installed"
    fi
  fi

  if _bruh_has tldr; then
    if command -v tldr &>/dev/null; then
      echo "\n📖 Refreshing tldr cache..."
      if [ $DRY -eq 1 ]; then
        echo "   [dry-run] would run: tldr --update"
        _bruh_set tldr "dry-run"
      elif tldr --update 2>/dev/null || tldr -u; then
        _bruh_set tldr "ok"
      else
        _bruh_set tldr "failed"
      fi
    else
      echo "\n📖 Skipping tldr (not installed)"
      _bruh_set tldr "not installed"
    fi
  fi

  if _bruh_has macos; then
    echo "\n🍏 Checking for macOS system updates (Apple's servers can be slow, ~30–60s)..."
    local sw_updates
    sw_updates=$(softwareupdate -l 2>&1)
    if echo "$sw_updates" | grep -q "No new software available"; then
      echo "   No macOS updates available."
      _bruh_set macos "up to date"
    else
      echo "$sw_updates"
      echo "   To install: sudo softwareupdate -i -a  (may require restart)"
      _bruh_set macos "updates available"
      _bruh_note "🍏 macOS updates available — run: sudo softwareupdate -i -a (may require restart)"
    fi
  fi

  if _bruh_has cleanup; then
    echo "\n🧹 Removing unused dependencies..."
    rc=0
    _bruh_run brew autoremove; rc=$?
    echo "\n🧼 Cleaning up old downloads..."
    _bruh_run brew cleanup -s; (( rc |= $? ))
    echo "\n🩺 Running brew doctor..."
    if [ $DRY -eq 1 ]; then
      echo "   [dry-run] would run: brew doctor"
    else
      brew doctor 2>&1 | grep -v -E "(ykpiv|ykcs11|libcrypto|libz\.1|openssl|zlib\.h)" || true
    fi
    [ $rc -eq 0 ] && _bruh_set cleanup "ok" || _bruh_set cleanup "failed"
  fi

  unset -f _bruh_has _bruh_run _bruh_set _bruh_note

  local suffix=""
  [ $DRY -eq 1 ] && suffix=" (dry-run)"

  local elapsed=$(( $(date +%s) - _bruh_t0 ))
  local mins=$((elapsed / 60)) secs=$((elapsed % 60))
  local elapsed_str
  if [ $mins -gt 0 ]; then
    elapsed_str="${mins}m ${secs}s"
  else
    elapsed_str="${secs}s"
  fi

  local -a updated skipped failed info noop
  local step st entry note
  for step in "${steps[@]}"; do
    st="${BRUH_STATUS[$step]:-(no status)}"
    case "$st" in
      ok*|"would update"*) updated+=("$step|$st") ;;
      "up to date"|dry-run) info+=("$step|$st") ;;
      "updates available"*) info+=("$step|$st") ;;
      failed*) failed+=("$step|$st") ;;
      "not installed"|"no globals"*|"no outdated"*) skipped+=("$step|$st") ;;
      *) noop+=("$step|$st") ;;
    esac
  done

  echo "\n📋 bruh summary${suffix} — ${elapsed_str}"

  if [ ${#updated[@]} -gt 0 ]; then
    echo "\n✅ Updated (${#updated[@]})"
    for entry in "${updated[@]}"; do
      printf "   %-10s %s\n" "${entry%%|*}" "${entry#*|}"
    done
  fi

  if [ ${#info[@]} -gt 0 ]; then
    echo "\nℹ️  Info (${#info[@]})"
    for entry in "${info[@]}"; do
      printf "   %-10s %s\n" "${entry%%|*}" "${entry#*|}"
    done
  fi

  if [ ${#skipped[@]} -gt 0 ]; then
    echo "\n⚠️  Skipped (${#skipped[@]})"
    for entry in "${skipped[@]}"; do
      printf "   %-10s %s\n" "${entry%%|*}" "${entry#*|}"
    done
  fi

  if [ ${#failed[@]} -gt 0 ]; then
    echo "\n❌ Failed (${#failed[@]})"
    for entry in "${failed[@]}"; do
      printf "   %-10s %s\n" "${entry%%|*}" "${entry#*|}"
    done
  fi

  if [ ${#args[@]} -eq 0 ] && [ ${#BRUH_DISABLED[@]} -gt 0 ]; then
    echo "\n⏭  Disabled via config (${#BRUH_DISABLED[@]})"
    echo "   ${BRUH_DISABLED[*]}"
  fi

  if [ ${#BRUH_NOTES[@]} -gt 0 ]; then
    echo "\n📌 Action items"
    for note in "${BRUH_NOTES[@]}"; do
      echo "   $note"
    done
  fi

  echo
  local n_up=${#updated[@]} n_sk=${#skipped[@]} n_info=${#info[@]} n_fail=${#failed[@]}
  # Tally the actual packages/formulae/casks/apps from each tool's "ok (N ...)" detail
  local total_items=0 entry_n num
  for entry in "${updated[@]}"; do
    for num in ${(s: :)${${entry#*|}//[^0-9]/ }}; do
      total_items=$(( total_items + num ))
    done
  done
  local -a parts
  local up_str="freshened up $n_up $([ $n_up -eq 1 ] && echo tool || echo tools)"
  [ $total_items -gt 0 ] && up_str+=" ($total_items $([ $total_items -eq 1 ] && echo package || echo packages) in all)"
  [ $n_up -gt 0 ]   && parts+=("$up_str")
  [ $n_sk -gt 0 ]   && parts+=("skipped $n_sk")
  [ $n_info -gt 0 ] && parts+=("$n_info already current")
  local joined
  case ${#parts[@]} in
    0) joined="nothing to do" ;;
    1) joined="${parts[1]}" ;;
    *) joined="${(j:, :)parts[1,-2]} and ${parts[-1]}" ;;
  esac
  if [ $n_fail -gt 0 ]; then
    echo "💥 Finished in ${elapsed_str}${suffix}, but $n_fail $([ $n_fail -eq 1 ] && echo step || echo steps) failed — peek at the ❌ section above. (Otherwise ${joined}.)"
  elif [ $n_up -eq 0 ]; then
    echo "👍 All quiet in ${elapsed_str}${suffix} — everything was already up to date."
  else
    echo "✨ All set in ${elapsed_str}${suffix} — ${joined}."
  fi

  # Offer to auto-disable tools that aren't installed (only for full runs, not dry-run)
  if [ ${#args[@]} -eq 0 ] && [ $DRY -eq 0 ] && [ -t 0 ] && [[ "$BRUH_PROMPT_DISABLE" != "false" ]]; then
    local -a to_disable
    for entry in "${skipped[@]}"; do
      [[ "${entry#*|}" == "not installed" ]] && to_disable+=("${entry%%|*}")
    done
    if [ ${#to_disable[@]} -gt 0 ]; then
      echo
      echo "💡 Add these never-installed tools to bruh's disabled list?"
      echo "   ${to_disable[*]}"
      echo "   [y]es  [n]o  [s]top asking (sets prompt_disable = false)"
      printf "   > "
      local reply
      read -r reply
      case "${reply:l}" in
        y|yes)
          local merged=("${BRUH_DISABLED[@]}" "${to_disable[@]}")
          _bruh_upsert_key disabled "${merged[*]}" "$config_file"
          echo "   ✓ Added to disabled list in $config_file"
          ;;
        s|stop|never)
          _bruh_upsert_key prompt_disable false "$config_file"
          echo "   ✓ Won't ask again (prompt_disable = false in $config_file)"
          ;;
        *)
          echo "   skipped"
          ;;
      esac
    fi
  fi

  unset -f _bruh_upsert_key _bruh_step_cmd
  [ ${#failed[@]} -gt 0 ] && return 1
  return 0
}

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

. "$HOME/.cargo/env"
