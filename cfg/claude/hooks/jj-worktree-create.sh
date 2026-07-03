#!/usr/bin/env bash
# Claude Code WorktreeCreate hook.
# Stdin: JSON with .name. Stdout: the created worktree path (required by Claude Code).
# In a jj repo, creates a jj workspace; in a plain git repo, falls back to git worktree.
set -euo pipefail

name=$(jq -r '.name')
name=${name//\//-}

if root=$(jj root 2>/dev/null); then
  dir="$root/.claude/worktrees/$name"
  mkdir -p "$root/.claude/worktrees"
  jj workspace add --name "$name" "$dir" >&2
else
  root=$(git rev-parse --show-toplevel)
  dir="$root/.claude/worktrees/$name"
  git worktree add -b "worktree-$name" "$dir" >&2
fi

echo "$dir"
