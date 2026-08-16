{
  inputs,
  system,
  ...
}: {
  environment.systemPackages = with inputs.llm-agents.packages."${system}"; [
    crush
    claude-code
    cursor-agent
    opencode
    pi
  ];
  nixpkgs.config.allowUnfree = true;
}
