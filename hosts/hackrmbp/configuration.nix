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
    ../../modules/macos/nh.nix
  ];

  networking.hostName = "hackrmbp";

  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
