#!/usr/bin/env bash
# Sync manuscript/, scripts/*.R, and AGENTS.md to the Overleaf clone.
# manuscript/references.bib is a symlink to the Zotero-updated global file;
# rsync -L copies its contents, since the Overleaf git bridge cannot follow it.
# Usage: ./sync-overleaf.sh          copy and show status
#        ./sync-overleaf.sh --push   also commit, push, and stage overleaf/
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
OL="$ROOT/overleaf"
PUSH=0
[[ "${1:-}" == "--push" ]] && PUSH=1

git -C "$OL" fetch origin main
incoming="$(git -C "$OL" log --oneline HEAD..origin/main)"
if [[ -n "$incoming" ]]; then
  echo "Overleaf has commits not yet reviewed. Inspect with 'git -C overleaf log -p HEAD..origin/main',"
  echo "reapply any web edits, then rebase and rerun:"
  echo "$incoming"
  exit 1
fi

if [[ -L "$OL/manuscript/references.bib" ]]; then
  echo "Overleaf references.bib is a symlink; remove it before syncing." >&2
  exit 1
fi

rsync -rLc --delete \
  --exclude='.git' --exclude='main.aux' --exclude='main.bbl' --exclude='main.blg' \
  --exclude='main.log' --exclude='main.out' --exclude='main.pdf' --exclude='main.synctex.gz' \
  "$ROOT/manuscript/" "$OL/manuscript/"
rsync -rc --delete --include='*.R' --exclude='*' "$ROOT/scripts/" "$OL/scripts/"
rsync -c "$ROOT/AGENTS.md" "$OL/AGENTS.md"

if cmp -s "$ROOT/manuscript/references.bib" "$OL/manuscript/references.bib"; then
  echo "references.bib: matches the global file"
else
  echo "references.bib: MISMATCH after copy" >&2
  exit 1
fi

git -C "$OL" status --short

if (( PUSH )); then
  git -C "$OL" add -A
  if git -C "$OL" diff --cached --quiet; then
    echo "No changes to commit."
  else
    git -C "$OL" commit -q -m "Sync manuscript from workspace ($(date +%Y-%m-%d))"
    git -C "$OL" push origin HEAD:main
    git -C "$ROOT" add overleaf
    echo "Pushed; overleaf gitlink staged in the workspace repo (not committed)."
  fi
fi
