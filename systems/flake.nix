{
  # Local nix-systems set: the four default systems minus x86_64-darwin,
  # which nixpkgs unstable (26.11+) has dropped. Used to constrain the
  # `systems` input of flakes (hunk, llm-agents, their bun2nix) that would
  # otherwise evaluate x86_64-darwin against our unstable nixpkgs and throw.
  description = "Supported systems for this config (default minus x86_64-darwin)";
  outputs = _: {};
}
