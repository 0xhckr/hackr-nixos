{
  self,
  pkgs,
  inputs,
  ...
}:
{
  system.primaryUser = "hackr";

  imports = [
    ../../modules/macos/user-cfg.nix
    ../../modules/macos/defaults.nix
    ../../modules/macos/homebrew.nix
  ];

  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
