{
  inputs,
  system,
  ...
}: {
  environment.systemPackages = with inputs.llm-agents.packages."${system}"; [
    crush
    claude-code
    opencode
  ];
  nixpkgs.config.allowUnfree = true;
}
