# Claude Code: jj-aware worktree hooks (source-of-truth in cfg/claude/).
# Mirrors the macOS config (modules/darwin/home/claude.nix).
#
# Claude Code's native --worktree shells out to `git worktree`, which breaks in
# jj colocated repos (and the resulting worktree has no .jj), so the
# WorktreeCreate/WorktreeRemove hooks delegate to `jj workspace` instead.
# Claude Code mutates ~/.claude/settings.json at runtime (model, effort, ...),
# so it can't be a store symlink — following the pi/niri pattern, an activation
# step merges just the two hook keys into whatever is already there.
{
  lib,
  pkgs,
  ...
}: {
  home.file = {
    ".claude/hooks/jj-worktree-create.sh" = {
      source = ../../../cfg/claude/hooks/jj-worktree-create.sh;
      executable = true;
      force = true;
    };
    ".claude/hooks/jj-worktree-remove.sh" = {
      source = ../../../cfg/claude/hooks/jj-worktree-remove.sh;
      executable = true;
      force = true;
    };
  };

  home.activation.claudeWorktreeHooks = lib.hm.dag.entryAfter ["linkGeneration"] ''
    #!/usr/bin/env bash
    settings="$HOME/.claude/settings.json"
    mkdir -p "$HOME/.claude"
    [ -s "$settings" ] || echo '{}' > "$settings"
    ${pkgs.jq}/bin/jq \
      '.hooks.WorktreeCreate = [{hooks: [{type: "command", command: "~/.claude/hooks/jj-worktree-create.sh"}]}]
       | .hooks.WorktreeRemove = [{hooks: [{type: "command", command: "~/.claude/hooks/jj-worktree-remove.sh"}]}]' \
      "$settings" > "$settings.tmp" && mv "$settings.tmp" "$settings"
  '';
}
