#!/bin/bash
# =============================================================================
# push-backend.sh — Sync backend/ subtree to the colony_backend repo.
# Run from the root of colony-app after every commit.
#
# Usage (from colony-app root):
#   bash push-backend.sh          ← push current HEAD
#   bash push-backend.sh "msg"    ← commit with message first, then push
# =============================================================================

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'
info()    { echo -e "${CYAN}[INFO]${RESET}  $*"; }
success() { echo -e "${GREEN}[OK]${RESET}    $*"; }
fatal()   { echo -e "${RED}[ERROR]${RESET} $*" >&2; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"

# Ensure we are at the git root
cd "$REPO_ROOT"
git rev-parse --show-toplevel &>/dev/null || fatal "Not inside a git repository."

# ── Ensure remote is set up ────────────────────────────────────────────────────
if ! git remote get-url colony-backend &>/dev/null; then
    info "Adding remote 'colony-backend'..."
    git remote add colony-backend https://github.com/devamskshinde/colony-backend.git
    success "Remote added."
fi

# ── Optional: commit first ─────────────────────────────────────────────────────
if [[ -n "${1:-}" ]]; then
    info "Committing with message: $1"
    git add -A
    git commit -m "$1" || true
fi

# ── Push main repo ─────────────────────────────────────────────────────────────
info "Pushing colony-app (main repo)..."
git push origin main 2>&1 || git push origin master 2>&1 || warn "Main push failed."

# ── Push backend subtree ───────────────────────────────────────────────────────
info "Pushing backend/ subtree to colony-backend..."
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
git subtree push --prefix=backend colony-backend main 2>&1 || {
    warn "Subtree push failed. Trying force..."
    git subtree split --prefix=backend -b backend-split-tmp
    git push colony-backend backend-split-tmp:main --force
    git branch -D backend-split-tmp
}

success "Both repos updated!"
echo ""
echo -e "  ${BOLD}colony-app:${RESET}     https://github.com/devamskshinde/colony-app"
echo -e "  ${BOLD}colony-backend:${RESET}  https://github.com/devamskshinde/colony-backend"
