#!/usr/bin/env bash
set -euo pipefail

# Deploy `docs/` to GitHub Pages.
# Usage:
#   ./deploy.sh            # auto: try subtree, fallback to orphan push to gh-pages
#   ./deploy.sh gh-pages   # force gh-pages branch deployment
#   ./deploy.sh docs       # commit docs to current branch (useful if Pages set to main/docs)

REMOTE=${REMOTE:-origin}
MODE=${1:-auto}
BRANCH=${BRANCH:-gh-pages}

echo "Deploy mode: ${MODE} (remote=${REMOTE}, branch=${BRANCH})"

if [ "${MODE}" = "docs" ]; then
  # Commit docs/ changes to current branch (use if Pages is configured to use main/docs)
  echo "Committing docs/ to current branch"
  git add docs
  if git diff --staged --quiet; then
    echo "No changes in docs/ to commit. Nothing to do."
    exit 0
  fi
  git commit -m "Update docs/ (deploy)"
  echo "Pushing to ${REMOTE} $(git rev-parse --abbrev-ref HEAD)"
  git push ${REMOTE} HEAD
  echo "Done."
  exit 0
fi

if [ "${MODE}" = "auto" ]; then
  # try subtree push first
  if git help -a | grep -q "subtree"; then
    echo "Using git subtree to push docs/ to ${REMOTE}/${BRANCH}"
    git subtree push --prefix docs ${REMOTE} ${BRANCH} && exit 0 || echo "subtree push failed, falling back"
  fi
fi

echo "Using orphan-branch deployment to ${REMOTE}/${BRANCH}"

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "Current branch: ${CURRENT_BRANCH}"

# Create orphan branch, commit contents of docs/ as root, push, then return
if git show-ref --quiet refs/heads/${BRANCH}; then
  git branch -D ${BRANCH}
fi

# Create orphan branch
git checkout --orphan ${BRANCH}
# Clear index and working tree (keep files on disk)
git reset --hard

# Remove all tracked files from index
git rm -rf . >/dev/null 2>&1 || true

# Add the files from docs/ into the index and commit
git --work-tree=docs add --all
if git --work-tree=docs diff --staged --quiet; then
  # No changes to deploy, create an empty commit to keep branch.
  GIT_COMMITTER_DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")" git commit --allow-empty -m "Deploy to ${BRANCH}: no changes"
else
  git --work-tree=docs commit -m "Deploy to ${BRANCH}: $(date -u +"%Y-%m-%d %H:%M:%S UTC")"
fi

git push ${REMOTE} ${BRANCH} --force

# Return to previous branch
git checkout ${CURRENT_BRANCH}
git branch -D ${BRANCH} || true

echo "Deployment finished."
