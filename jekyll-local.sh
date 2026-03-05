#!/usr/bin/env bash
#
# jekyll-local.sh — Build and serve a Jekyll site locally
#
# Usage: ./jekyll-local.sh [build|serve|both]
#   build  — Build the site only
#   serve  — Serve the site only (skips explicit build; serve implies build)
#   both   — Build first, then serve (default)
#

set -euo pipefail

PORT="${JEKYLL_PORT:-4000}"
HOST="${JEKYLL_HOST:-0.0.0.0}"

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

log()  { echo -e "${GREEN}[jekyll]${NC} $*"; }
info() { echo -e "${CYAN}[jekyll]${NC} $*"; }
err()  { echo -e "${RED}[jekyll]${NC} $*" >&2; }

# --- Pre-flight checks -------------------------------------------------------

if ! command -v bundle &>/dev/null; then
    err "bundler not found. Install it with:  gem install bundler"
    exit 1
fi

if [[ ! -f "Gemfile" ]]; then
    err "No Gemfile found in $(pwd). Run this from your Jekyll project root."
    exit 1
fi

# --- Ensure dependencies are installed ----------------------------------------

log "Installing/updating bundle dependencies..."
bundle install --quiet

# --- Actions ------------------------------------------------------------------

do_build() {
    log "Building site..."
    bundle exec jekyll build
    log "Build complete.  Output in ./_site"
}

do_serve() {
    info "Serving at http://${HOST}:${PORT}  (Ctrl-C to stop)"
    bundle exec jekyll serve --host "${HOST}" --port "${PORT}"
}

# --- Main ---------------------------------------------------------------------

ACTION="${1:-both}"

case "${ACTION}" in
    build)
        do_build
        ;;
    serve)
        do_serve
        ;;
    both)
        do_build
        do_serve
        ;;
    *)
        err "Unknown action: ${ACTION}"
        echo "Usage: $0 [build|serve|both]"
        exit 1
        ;;
esac