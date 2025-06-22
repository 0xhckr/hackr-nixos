{ pkgs, ... }:
{
  imports = [
    ./ssh.nix
    ./terminal.nix
    ./ui.linux.nix
    ./apps.nix
    ./dev.nix
  ];

  home.username = "hackr";
  home.homeDirectory = "/home/hackr";

  home.stateVersion = "24.11";
  nixpkgs.config.allowUnfree = true;

  home.file = {
    ".config/ghostty" = {
      force = true;
      source = ../../cfg/linux/ghostty;
      recursive = true;
    };
    ".config/hypr" = {
      force = true;
      source = ../../cfg/linux/hypr;
      recursive = true;
    };
    ".config/niri" = {
      force = true;
      source = ../../cfg/linux/niri;
      recursive = true;
    };
    ".config/sherlock" = {
      force = true;
      source = ../../cfg/linux/sherlock;
      recursive = true;
    };
    ".config/waybar" = {
      force = true;
      source = ../../cfg/linux/waybar;
      recursive = true;
    };
    ".config/wlogout" = {
      force = true;
      source = ../../cfg/linux/wlogout;
      recursive = true;
    };
    ".config/alacritty" = {
      force = true;
      source = ../../cfg/shared/alacritty;
      recursive = true;
    };
    ".config/atuin" = {
      force = true;
      source = ../../cfg/shared/atuin;
      recursive = true;
    };
    ".config/btop" = {
      force = true;
      source = ../../cfg/shared/btop;
      recursive = true;
    };
    ".config/direnv" = {
      force = true;
      source = ../../cfg/shared/direnv;
      recursive = true;
    };
    ".config/fastfetch" = {
      force = true;
      source = ../../cfg/shared/fastfetch;
      recursive = true;
    };
    ".config/nushell" = {
      force = true;
      source = ../../cfg/shared/nushell;
      recursive = true;
    };
    ".config/walls" = {
      force = true;
      source = ../../cfg/shared/walls;
      recursive = true;
    };
    ".config/starship.toml" = {
      force = true;
      source = ../../cfg/shared/starship.toml;
    };
  };

  programs.home-manager.enable = true;
}
