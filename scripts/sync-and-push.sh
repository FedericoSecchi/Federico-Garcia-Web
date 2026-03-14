#!/usr/bin/env bash
# Force-fix git sync and push to origin/main for GitHub Pages deploy.
# Run from repo root: bash scripts/sync-and-push.sh

set -e
cd "$(git rev-parse --show-toplevel)"

REMOTE="${1:-origin}"
BRANCH="${2:-main}"

echo "=== 1. Remote ==="
git remote -v
if ! git remote get-url "$REMOTE" &>/dev/null; then
  echo "Adding remote $REMOTE = git@github.com:FedericoSecchi/Federico-Garcia.git"
  git remote add origin git@github.com:FedericoSecchi/Federico-Garcia.git
fi

echo ""
echo "=== 2. Fetch (prune) ==="
git fetch "$REMOTE" --prune

echo ""
echo "=== 3. Divergence check ==="
LOCAL=$(git rev-parse "$BRANCH")
ORIGIN="$REMOTE/$BRANCH"
if ! git rev-parse "$ORIGIN" &>/dev/null; then
  echo "No $ORIGIN yet; push will create it."
else
  REMOTE_REF=$(git rev-parse "$ORIGIN")
  echo "Local $BRANCH: $LOCAL"
  echo "Remote $ORIGIN: $REMOTE_REF"
  if [ "$LOCAL" = "$REMOTE_REF" ]; then
    echo "Already in sync. Exiting."
    exit 0
  fi
fi

echo ""
echo "=== 4. Sync main (rebase first) ==="
git checkout "$BRANCH"
if git pull "$REMOTE" "$BRANCH" --rebase 2>/dev/null; then
  echo "Rebase pull OK."
else
  echo "Rebase failed; trying merge pull..."
  git rebase --abort 2>/dev/null || true
  git pull "$REMOTE" "$BRANCH"
fi

echo ""
echo "=== 5. Push ==="
PUSH_OK=0
git push "$REMOTE" "$BRANCH" 2>/dev/null && PUSH_OK=1
if [ "$PUSH_OK" = "0" ]; then
  echo "Normal push failed. Trying --force-with-lease..."
  git push "$REMOTE" "$BRANCH" --force-with-lease 2>/dev/null && PUSH_OK=1
fi
if [ "$PUSH_OK" = "0" ] && [ "${FORCE}" = "1" ]; then
  echo "FORCE=1: overwriting remote with local main..."
  git push "$REMOTE" "$BRANCH" --force
  PUSH_OK=1
fi
if [ "$PUSH_OK" = "0" ]; then
  echo "Push failed. From your machine run: git fetch origin && git pull origin main --rebase && git push origin main"
  echo "Or to overwrite remote: FORCE=1 bash scripts/sync-and-push.sh"
  exit 1
fi
echo "Push OK."

echo ""
echo "=== 6. Verify ==="
git fetch "$REMOTE" 2>/dev/null || true
echo "Local:  $(git log -1 --oneline $BRANCH)"
echo "Remote: $(git log -1 --oneline $ORIGIN 2>/dev/null || echo 'N/A')"
echo "Done."
