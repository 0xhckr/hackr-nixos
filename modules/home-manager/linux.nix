{ pkgs, inputs, hostname, ... }:
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
    ".config/jj" = {
      force = true;
      source = ../../cfg/linux/jj;
      recursive = true;
    };
    ".config/niri/config.kdl" = {
      force = true;
      text = ''
        ${builtins.readFile ../../cfg/linux/niri/config.kdl}
        ${if hostname == "hackrwork" || hostname == "hackrfrmw" then ''
          ${builtins.readFile ../../cfg/linux/niri/laptop-outputs.kdl}
        '' else ""}
      '';
    };
    ".config/niri/delayed" = {
      force = true;
      source = ../../cfg/linux/niri/delayed;
    };
    ".config/niri/background" = {
      force = true;
      source = ../../cfg/linux/niri/background;
    };
    ".config/nixpkgs/config.nix" = {
      force = true;
      source = ../../cfg/linux/nixpkgs/config.nix;
    };
    ".config/noctalia" = {
      force = true;
      source = ../../cfg/linux/noctalia;
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
    ".config/commie" = {
      force = true;
      source = ../../cfg/shared/commie;
      recursive = true;
    };
    ".config/direnv" = {
      force = true;
      source = ../../cfg/shared/direnv;
      recursive = true;
    };
    ".config/fastfetch/config.jsonc" = {
      force = true;
      source = ../../cfg/shared/fastfetch/config.linux.jsonc;
    };
    ".config/fastfetch/infernape.png" = {
      force = true;
      source = ../../cfg/shared/fastfetch/infernape.png;
    };
    ".local/share/vicinae/themes" = {
      force = true;
      source = ../../share/vicinae/themes;
      recursive = true;
    };
  };

  programs.home-manager.enable = true;
}
