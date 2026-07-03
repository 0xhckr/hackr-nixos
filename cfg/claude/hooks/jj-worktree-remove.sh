#!/usr/bin/env bash
# Claude Code WorktreeRemove hook — counterpart to jj-worktree-create.sh.
# Forgets the jj workspace (or removes the git worktree), then deletes the directory.
set -euo pipefail

input=$(cat)
path=$(jq -r '.path // .worktreePath // .worktree_path // empty' <<<"$input")
name=$(jq -r '.name // empty' <<<"$input")

if [ -n "$path" ] && [ -e "$path/.jj" ]; then
  jj -R "$path" workspace forget >&2 || true
elif [ -n "$name" ] && jj root >/dev/null 2>&1; then
  jj workspace forget "$name" >&2 || true
elif [ -n "$path" ] && git -C "$path" rev-parse --git-dir >/dev/null 2>&1; then
  git -C "$path" worktree remove --force "$path" >&2 || true
fi

# Only delete directories we created under .claude/worktrees/
case "$path" in
  */.claude/worktrees/*) [ -d "$path" ] && rm -rf "$path" ;;
esac
