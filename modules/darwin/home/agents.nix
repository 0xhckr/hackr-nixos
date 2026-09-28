# Share the NixOS agent set on every Mac except metagross, which only has Claude.
{
  inputs,
  system,
  hostname,
  lib,
  ...
}: let
  agents = inputs.llm-agents.packages.${system};
in {
  home.packages = [agents.claude-code] ++ lib.optionals (hostname != "metagross") [
    agents.crush
    agents.opencode2
  ];

  home.file = {
    ".claude/CLAUDE.md" = {
      force = true;
      source = ../../../cfg/agents/AGENTS.md;
    };
  } // lib.optionalAttrs (hostname != "metagross") {
    ".config/opencode/AGENTS.md" = {
      force = true;
      source = ../../../cfg/agents/AGENTS.md;
    };
  };
}
