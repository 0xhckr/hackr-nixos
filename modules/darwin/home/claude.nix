# Claude Code: jj-aware worktree hooks (source-of-truth in cfg/claude/).
# Mirrors the NixOS config (modules/home-manager/dev/claude.nix) — see the
# comments there for the full rationale.
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
