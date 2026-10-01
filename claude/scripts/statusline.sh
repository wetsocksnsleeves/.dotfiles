#!/usr/bin/env bash
# Claude Code status-line - git branch | context used %
input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
[ -z "$cwd" ] && cwd=$(pwd)

# --- git branch ------------------------------------------------------------
git_seg=''
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  br=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)
  [ -z "$br" ] && br='(detached)'

  dirty=''
  git -C "$cwd" diff --quiet 2>/dev/null &&
  git -C "$cwd" diff --quiet --cached 2>/dev/null || dirty='*'

  git_seg="${br}${dirty}"
fi

# --- context used % --------------------------------------------------------
ctx_seg=''
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty | floor')
if [ -n "$used" ] && [ "$used" != "null" ]; then
  [ "$used" -lt 0 ] && used=0
  [ "$used" -gt 100 ] && used=100
  ctx_seg="${used}%"
fi

# --- assemble --------------------------------------------------------------
out=''
[ -n "$git_seg" ] && out="$git_seg"
if [ -n "$ctx_seg" ]; then
  [ -n "$out" ] && out="$out | $ctx_seg" || out="$ctx_seg"
fi

[ -n "$out" ] && echo "$out"
