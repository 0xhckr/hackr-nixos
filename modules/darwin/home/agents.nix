# LLM coding agents. Mirrors the NixOS config (modules/nixos/apps/dev/agents.nix),
# which installs the full set (crush, claude-code, opencode, pi) from the shared
# llm-agents.nix flake input. Here we only want claude-code. Add more from
# inputs.llm-agents.packages.${system} as needed.
#
# The global instructions in cfg/agents/AGENTS.md are shared with the NixOS
# hosts (linked in modules/home-manager/links.nix). Only claude-code is
# installed here, so only its path is linked; add the opencode/codex entries
# from links.nix if those agents ever land on this machine.
{
  inputs,
  system,
  ...
}: {
  home.packages = [
    inputs.llm-agents.packages.${system}.claude-code
  ];

  home.file.".claude/CLAUDE.md" = {
    force = true;
    source = ../../../cfg/agents/AGENTS.md;
  };
}
