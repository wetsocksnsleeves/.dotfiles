#!/usr/bin/env bash
# Classify the branch diff into visual / possibly-visual / non-visual files.
# Usage: detect_visual_changes.sh [base_ref]   (default: master)
set -euo pipefail

BASE="${1:-master}"
MERGE_BASE="$(git merge-base "$BASE" HEAD)"

CHANGED="$(git diff --name-only "$MERGE_BASE"...HEAD; git diff --name-only; git ls-files --others --exclude-standard)"
CHANGED="$(printf '%s\n' "$CHANGED" | sort -u | sed '/^$/d')"

VISUAL_RE='\.(haml|erb|slim|scss|sass|css|tsx|jsx|vue)$|^app/(views|components|assets|javascript)/|^webpack/|tailwind\.config|^app/frontend/'
MAYBE_RE='^app/helpers/|^app/presenters/|^app/decorators/|^app/models/concerns/.*presenter|_helper\.rb$|^config/locales/|\.po$|^app/controllers/.*\.rb$'
TEST_RE='^test/|^spec/|_test\.rb$|\.test\.(js|ts|tsx|jsx)$|__tests__/'

visual="$(printf '%s\n' "$CHANGED" | grep -Ev "$TEST_RE" | grep -E "$VISUAL_RE" || true)"
maybe="$(printf '%s\n' "$CHANGED" | grep -Ev "$TEST_RE" | grep -Ev "$VISUAL_RE" | grep -E "$MAYBE_RE" || true)"
other="$(printf '%s\n' "$CHANGED" | grep -Ev "$VISUAL_RE" | grep -Ev "$MAYBE_RE" || true)"

echo "base:   $BASE ($MERGE_BASE)"
echo "branch: $(git branch --show-current)"
echo
echo "VISUAL:"
printf '%s\n' "$visual" | sed '/^$/d' | sed 's/^/  /'
echo
echo "MAYBE VISUAL (renders or supplies markup/copy):"
printf '%s\n' "$maybe" | sed '/^$/d' | sed 's/^/  /'
echo
echo "NON-VISUAL:"
printf '%s\n' "$other" | sed '/^$/d' | sed 's/^/  /'
echo

if [ -n "$visual" ]; then
  echo "VERDICT: visual — run the capture workflow"
elif [ -n "$maybe" ]; then
  echo "VERDICT: possibly visual — inspect the MAYBE files before deciding"
else
  echo "VERDICT: not visual — skip visual QA"
fi
