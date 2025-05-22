{
  self,
  pkgs,
  inputs,
  ...
}:
{
  system.primaryUser = "hackr";

  imports = [
    ../../modules/nixos/user-cfg.nix
    ../../modules/macos/defaults.nix
    ../../modules/macos/homebrew.nix
  ];

  environment.variables = {
    ZDOTDIR = "$HOME/.config/zsh";
    XDG_CONFIG_HOME = "$HOME/.config";
  };

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;
  };

  nix = {
    enable = true;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";

  security.pam.services.sudo_local.touchIdAuth = true;
}
