{ ... }:
{
  imports = [
    ./ssh.nix
    ./terminal.nix
    ./ui.nix
    ./apps.nix
    ./dev.nix
  ];

  home.username = "hackr";
  home.homeDirectory = "/home/hackr";
  home.stateVersion = "24.11";
  nixpkgs.config.allowUnfree = true;

  home.file = {
    ".config/" = {
      force = true;
      source = ../../cfg;
      recursive = true;
    };
  };

  programs.home-manager.enable = true;
}
