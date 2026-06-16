# LLM coding agents. Mirrors the NixOS config (modules/nixos/apps/dev/agents.nix),
# which installs the full set (crush, claude-code, opencode, pi) from the shared
# llm-agents.nix flake input — here we only want claude-code. Add more from
# inputs.llm-agents.packages.${system} as needed.
{
  inputs,
  system,
  ...
}: {
  home.packages = [
    inputs.llm-agents.packages.${system}.claude-code
  ];
}
