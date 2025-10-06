# ~/dev/github.com/jeanlucaslima/dotfiles/zsh/plugins/boil.zsh
# ☕ boil — update helper for Brew / npm / asdf (safe defaults)
#
# Usage:
#   boil                    -> brew + npm
#   boil brew               -> only brew
#   boil npm                -> only npm
#   boil asdf               -> LIST installed asdf tools (safe default)
#   boil asdf upgrade       -> update asdf core/plugins; install from .tool-versions
#   boil asdf upgrade --bump-latest
#                           -> also set each plugin to its latest version globally
#
# Flags:
#   --dry-run               -> print commands instead of running them
#   --help | -h             -> show this help
#
# Tips:
#   • Keep asdf deliberate: `boil asdf` to inspect, `boil asdf upgrade` to act.
#   • Try `boil --dry-run` before big updates.

boil() {
  local DRY_RUN=0 BUMP_LATEST=0
  local tasks=() ASDF_MODE="list"

  _boil_help() {
    cat <<'EOF'
☕ boil — update helper

Commands:
  boil                    brew + npm
  boil brew               only brew
  boil npm                only npm
  boil asdf               list installed asdf tool versions
  boil asdf upgrade       update asdf core/plugins; install missing from .tool-versions
  boil asdf upgrade --bump-latest
                          also set each plugin to its latest version globally

Flags:
  --dry-run               print commands without executing
  --help, -h              show this help

Notes:
  • npm step updates npm itself, then all global packages.
  • asdf is opt-in and safe by default (list only).
EOF
  }

  _need() {
    if ! command -v "$1" >/dev/null 2>&1; then
      echo "⚠️  Missing command: $1 — skipping this section."
      return 1
    fi
    return 0
  }

  # Parse args (order-agnostic)
  if [[ $# -eq 0 ]]; then
    tasks=(brew npm)   # default
  else
    for arg in "$@"; do
      case "$arg" in
        --help|-h) _boil_help; return 0 ;;
        --dry-run) DRY_RUN=1 ;;
        --bump-latest) BUMP_LATEST=1 ;;
        all) tasks=(brew npm) ;;            # asdf remains opt-in by design
        brew|npm|asdf) tasks+=("$arg") ;;
        upgrade) ASDF_MODE="upgrade" ;;
        *) ;; # ignore unknown tokens quietly
      esac
    done
    [[ ${#tasks[@]} -eq 0 ]] && tasks=(brew npm)
  fi

  # Runner wrapper
  local _run
  if [[ $DRY_RUN -eq 1 ]]; then
    _run() { echo "DRY-RUN: $*"; }
  else
    _run() { eval "$@"; }
  fi

  # ── Brew ────────────────────────────────────────────────────────────────
  if [[ " ${tasks[*]} " == *" brew "* ]]; then
    if _need brew; then
      echo "🔄 Homebrew: update, upgrade, cleanup"
      _run "brew update"
      _run "brew upgrade"
      _run "brew cleanup"
      echo
    fi
  fi

  # ── npm ─────────────────────────────────────────────────────────────────
  if [[ " ${tasks[*]} " == *" npm "* ]]; then
    if _need npm; then
      echo "📦 npm: updating npm itself"
      _run "npm install -g npm"

      echo "🚀 npm: updating global packages"
      if [[ $DRY_RUN -eq 1 ]]; then
        npm outdated -g --depth=0 || true
      else
        local outdated
        outdated=$(npm outdated -g --parseable --depth=0 | cut -d: -f4)
        if [[ -z "$outdated" ]]; then
          echo "✅ Global npm packages are up to date."
        else
          echo "📦 Will update:"
          echo "$outdated" | sed 's/^/ - /'
          echo ""
          echo "$outdated" | xargs npm install -g
        fi
      fi
      echo
    fi
  fi

  # ── asdf ────────────────────────────────────────────────────────────────
  if [[ " ${tasks[*]} " == *" asdf "* ]]; then
    if _need asdf; then
      if [[ "$ASDF_MODE" == "list" ]]; then
        echo "📋 asdf: listing installed tools"
        _run "asdf list"
      else
        echo "🧩 asdf: updating core & plugins"
        _run "asdf update"
        _run "asdf plugin-update --all"

        if [[ -f ".tool-versions" ]]; then
          echo "📄 Installing any missing versions from .tool-versions"
          _run "asdf install"
        else
          echo "ℹ️  No .tool-versions found in current directory."
        fi

        if [[ $BUMP_LATEST -eq 1 ]]; then
          echo "⏫ asdf: bumping each plugin to its latest version (global)"
          local plugin latest
          while read -r plugin; do
            [[ -z "$plugin" ]] && continue
            latest=$(asdf latest "$plugin" 2>/dev/null)
            if [[ -n "$latest" ]]; then
              echo " - $plugin → $latest"
              _run "asdf install $plugin $latest"
              _run "asdf global $plugin $latest"
            else
              echo " - $plugin: latest not found"
            fi
          done < <(asdf plugin list)
          _run "asdf reshim"
        fi
      fi
      echo
    fi
  fi

  echo "✨ Done."
}
