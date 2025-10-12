#!/usr/bin/env bash

# Deploy the contents of ./docs to the gh-pages branch using a git worktree.
#
# Usage:
#   ./deploy-gh-pages.sh [remote] [source_dir]
#
# - remote:     Git remote to push to (default: origin)
# - source_dir: Directory with the built site (default: docs)
#
# Notes:
# - Requires git >= 2.5 for worktree support.
# - Preserves the CNAME file at repo root if present.
# - Creates a .nojekyll file to bypass Jekyll processing.

set -euo pipefail

REMOTE="${1:-origin}"
SOURCE_DIR="${2:-docs}"
WORKTREE_DIR=".gh-pages-tmp"

# Ensure we run from the repo root (script directory)
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
cd "${SCRIPT_DIR}"

if ! command -v git >/dev/null 2>&1; then
  echo "Error: git is not installed or not in PATH" >&2
  exit 1
fi

if [ ! -d .git ]; then
  echo "Error: This does not appear to be a git repository (no .git directory)" >&2
  exit 1
fi

if [ ! -d "${SOURCE_DIR}" ]; then
  echo "Error: Source directory '${SOURCE_DIR}' does not exist" >&2
  exit 1
fi

if [ ! -f "${SOURCE_DIR}/index.html" ]; then
  # Auto-detect Angular browser build under SOURCE_DIR/browser
  if [ -f "${SOURCE_DIR}/browser/index.html" ]; then
    echo "Detected Angular browser build at '${SOURCE_DIR}/browser'. Using that as source."
    SOURCE_DIR="${SOURCE_DIR}/browser"
  else
    echo "Warning: '${SOURCE_DIR}/index.html' not found. Are you sure the site is built?" >&2
  fi
fi

MAIN_SHA="$(git rev-parse --short HEAD)"
TIMESTAMP_UTC="$(date -u +"%Y-%m-%d %H:%M:%S UTC")"

# Clean up the worktree dir on exit if it exists
cleanup() {
  set +e
  if [ -d "${WORKTREE_DIR}" ]; then
    # Ensure we are not inside the worktree dir when removing it
    cd "${SCRIPT_DIR}" || true
    git worktree remove --force "${WORKTREE_DIR}" >/dev/null 2>&1 || true
    rm -rf "${WORKTREE_DIR}" 2>/dev/null || true
  fi
}
trap cleanup EXIT

echo "Using remote: ${REMOTE}"
echo "Source dir:  ${SOURCE_DIR}"

# Verify remote exists
if ! git remote get-url "${REMOTE}" >/dev/null 2>&1; then
  echo "Error: Remote '${REMOTE}' does not exist" >&2
  exit 1
fi

echo "Fetching '${REMOTE}'…"
git fetch --prune "${REMOTE}" >/dev/null 2>&1 || true

# Ensure local gh-pages branch exists (create/tracking if only on remote)
if git ls-remote --exit-code --heads "${REMOTE}" gh-pages >/dev/null 2>&1; then
  # Remote gh-pages exists
  if ! git show-ref --verify --quiet refs/heads/gh-pages; then
    echo "Creating local tracking branch 'gh-pages' from '${REMOTE}/gh-pages'"
    git branch gh-pages "${REMOTE}/gh-pages"
  fi
  echo "Adding worktree for branch 'gh-pages'"
  git worktree add -f "${WORKTREE_DIR}" gh-pages >/dev/null
else
  # Remote gh-pages does not exist; create a new branch based on an empty tree
  echo "Remote branch 'gh-pages' not found. Creating a new branch."
  # Create a local gh-pages starting from current HEAD (will replace contents below)
  git worktree add -B gh-pages "${WORKTREE_DIR}" "${MAIN_SHA}" >/dev/null
fi

echo "Syncing '${SOURCE_DIR}' to worktree '${WORKTREE_DIR}'…"

# Ensure rsync is available; if not, fall back to bash copy
if command -v rsync >/dev/null 2>&1; then
  rsync -av --delete --exclude .git --exclude .gitignore "${SOURCE_DIR}/" "${WORKTREE_DIR}/"
else
  # Fallback: remove everything then copy
  (cd "${WORKTREE_DIR}" && find . -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +)
  cp -a "${SOURCE_DIR}/." "${WORKTREE_DIR}/"
fi

# Add CNAME if present at repo root and not already in the source dir
if [ -f "CNAME" ]; then
  cp -f CNAME "${WORKTREE_DIR}/CNAME"
fi

# Ensure .nojekyll exists to prevent GitHub from running Jekyll
touch "${WORKTREE_DIR}/.nojekyll"

pushd "${WORKTREE_DIR}" >/dev/null

# Prevent accidental inclusion of the parent repo's gitignored files
echo -e "\n# Deployed artifacts only\n" >> .gitignore || true

echo "Preparing commit…"
git add -A

if git diff --cached --quiet; then
  echo "No changes to deploy. Exiting."
  popd >/dev/null
  exit 0
fi

COMMIT_MSG="Deploy site: ${TIMESTAMP_UTC} from ${MAIN_SHA}"
git commit -m "${COMMIT_MSG}"

echo "Pushing to '${REMOTE}' branch 'gh-pages'…"
git push "${REMOTE}" HEAD:gh-pages

popd >/dev/null

echo "Deployment completed successfully."
echo "- Commit: ${COMMIT_MSG}"
echo "- Branch: gh-pages -> ${REMOTE}/gh-pages"
