{
  inputs,
  system,
  ...
}: {
  environment.systemPackages = with inputs.llm-agents.packages."${system}"; [
    crush
    claude-code
    cursor-agent
    opencode2
    pi
  ];
  nixpkgs.config.allowUnfree = true;
}
