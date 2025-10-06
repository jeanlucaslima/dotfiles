# ~/dev/github.com/jeanlucaslima/dotfiles/zsh/plugins/dashboard.zsh
# 🌅 Startup Dashboard — fast, quiet, cache-friendly, and idempotent
#
# Configure via environment variables (set in .zshrc BEFORE sourcing plugins.zsh):
#   export DASHBOARD_SHOW_WEATHER=1        # show weather line (cached for 1h)
#   export DASHBOARD_SHOW_STATS=1          # show brew/npm outdated counts (cached for 30m)
#   export DASHBOARD_CITY="Sao+Paulo"      # city for wttr.in (default: Sao+Paulo)
#
# Added:
#   • Elixir version in runtimes (if installed)
#   • Postgres service status (uses pg_isready if available; else pgrep)

# ────────────────────── Idempotency guard ──────────────────────
# Prevent accidental double printing if sourced twice.
if [[ -n "${ZSH_DASHBOARD_PRINTED-}" ]]; then
  return
fi
export ZSH_DASHBOARD_PRINTED=1

# ───────────────────────── Colors ─────────────────────────
if command -v tput >/dev/null 2>&1; then
  BOLD=$(tput bold); RESET=$(tput sgr0)
  CYAN=$(tput setaf 6); GREEN=$(tput setaf 2)
  YELLOW=$(tput setaf 3); MAGENTA=$(tput setaf 5); DIM=$(tput dim); RED=$(tput setaf 1)
else
  BOLD=""; RESET=""; CYAN=""; GREEN=""; YELLOW=""; MAGENTA=""; DIM=""; RED=""
fi

# ──────────────── Cross-platform file mtime helper ─────────
# Prints epoch mtime or 0 if missing/unavailable
_mtime() {
  local f="$1"
  if [[ ! -e "$f" ]]; then
    echo 0; return
  fi
  # macOS/BSD stat
  if stat -f %m "$f" >/dev/null 2>&1; then
    stat -f %m "$f"; return
  fi
  # GNU/Linux stat
  if stat -c %Y "$f" >/dev/null 2>&1; then
    stat -c %Y "$f"; return
  fi
  echo 0
}

# ───────────── Cache helper: print now, refresh silently ─────────────
# Usage: _cached <cache_name> <ttl_seconds> <command...>
# Behavior:
#   • Prints cached content immediately (or "n/a" if none)
#   • If cache is stale/missing, refreshes in background WITHOUT printing
_cached() {
  local name="$1" ttl="$2"; shift 2
  local dir="${HOME}/.cache/zsh-dashboard"
  local file="${dir}/${name}.txt"
  mkdir -p "$dir"

  # Print cached content (if any)
  if [[ -s "$file" ]]; then
    cat "$file"
  else
    printf "n/a"
  fi

  # Safe integer math
  local -i now epoch ttl_i
  now=$(date +%s)
  epoch=$(_mtime "$file"); (( epoch = ${epoch:-0} ))
  ttl_i=${ttl:-0}

  # Refresh if stale (silent background) — note the quoted $file
  if (( now - epoch > ttl_i )) || [[ ! -s "$file" ]]; then
    ( "$@" >"${file}.tmp" 2>/dev/null && mv "${file}.tmp" "$file" ) >/dev/null 2>&1 &!
  fi
}

# ───────────── Helpers: versions & services ─────────────
_elixir_version() {
  # elixir -v prints something like:
  #   Erlang/OTP 27 [erts-13.2.2] ...
  #   Elixir 1.16.2 (compiled with Erlang/OTP 27)
  if command -v elixir >/dev/null 2>&1; then
    elixir -v 2>/dev/null | sed -n 's/^Elixir \([0-9][0-9.]*\).*/\1/p' | head -n1
  fi
}

_pg_status() {
  # prefer pg_isready for accuracy
  if command -v pg_isready >/dev/null 2>&1; then
    if pg_isready -q; then
      echo "running"
    else
      echo "stopped"
    fi
    return
  fi
  # fallback: process check
  if pgrep -x postgres >/dev/null 2>&1; then
    echo "running"
  else
    echo "stopped"
  fi
}

# ───────────────────────── Basics ─────────────────────────
: "${DASHBOARD_CITY:=Sao+Paulo}"

HOSTNAME=$(hostname)
DATE_STR=$(date +"%A, %d %B %Y")
TIME_STR=$(date +"%H:%M:%S")

NODE_VERSION=$(node -v 2>/dev/null || echo "n/a")
NPM_VERSION=$(npm -v 2>/dev/null || echo "n/a")
PY_VERSION=$(python3 --version 2>/dev/null || echo "n/a")
ELIXIR_VERSION=$(_elixir_version 2>/dev/null || echo "")

# Service status: Postgres
PG_STATUS=$(_pg_status 2>/dev/null || echo "unknown")
if [[ "$PG_STATUS" == "running" ]]; then
  PG_ICON="${GREEN}✅${RESET}"
else
  PG_ICON="${RED}✖${RESET}"
fi

# ─────────────── Header (prints immediately, once) ───────────────
echo ""
echo "${BOLD}${CYAN}👋 Welcome back, captain.${RESET} ${DIM}(zsh ready)${RESET}"
echo "📍 Host: ${MAGENTA}$HOSTNAME${RESET}"
echo "📆 $DATE_STR  ⏰ $TIME_STR"
echo ""
# Runtimes line with optional Elixir
if [[ -n "$ELIXIR_VERSION" ]]; then
  echo "📦 Runtimes: Node ${GREEN}$NODE_VERSION${RESET} • npm ${GREEN}$NPM_VERSION${RESET} • Python ${GREEN}$PY_VERSION${RESET} • Elixir ${GREEN}$ELIXIR_VERSION${RESET}"
else
  echo "📦 Runtimes: Node ${GREEN}$NODE_VERSION${RESET} • npm ${GREEN}$NPM_VERSION${RESET} • Python ${GREEN}$PY_VERSION${RESET}"
fi
echo "🗄️  Services: Postgres ${PG_ICON} ${DIM}(${PG_STATUS})${RESET}"
echo ""
echo "🧪 Updates: ${BOLD}boil${RESET} (brew+npm)  |  ${BOLD}boil asdf${RESET} (list)  |  ${BOLD}boil asdf upgrade${RESET}"
echo "💡 Tip: ${BOLD}boil --dry-run${RESET} to preview.  ${DIM}asdf changes are manual by design.${RESET}"

# ─────────────── Optional, cached sections (quiet) ───────────────
if [[ -n "$DASHBOARD_SHOW_WEATHER" ]]; then
  city_disp="${DASHBOARD_CITY//+/ }"
  weather="$(_cached "weather_${DASHBOARD_CITY}" 3600 curl -s "https://wttr.in/${DASHBOARD_CITY}?format=1")"
  echo "🌤️  Weather (${city_disp}): $weather"
fi

if [[ -n "$DASHBOARD_SHOW_STATS" ]]; then
  brew_n="n/a"
  if command -v brew >/dev/null 2>&1; then
    brew_n="$(_cached "brew_outdated_count" 1800 sh -c 'brew outdated 2>/dev/null | wc -l | tr -d " "')"
  fi
  npm_n="n/a"
  if command -v npm >/dev/null 2>&1; then
    npm_n="$(_cached "npm_outdated_global_count" 1800 sh -c 'npm outdated -g --depth=0 2>/dev/null | tail -n +2 | wc -l | tr -d " "')"
  fi
  echo "📊 Outdated: 🍺 Brew ${YELLOW}${brew_n}${RESET} • 📦 npm (global) ${YELLOW}${npm_n}${RESET}"
fi

echo ""