{ pkgs, ... }:
let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  imports = [
    ./ssh.nix
    ./terminal.nix
    ./ui.nix
    ./apps.nix
    ./dev.nix
  ];

  home.username = "hackr";
  home.homeDirectory = if isLinux then "/home/hackr" else "/Users/hackr";

  home.stateVersion = "24.11";
  nixpkgs.config.allowUnfree = true;

  home.file =
    if isLinux then
      {
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
        ".config/starship.toml" = {
          force = true;
          source = ../../cfg/shared/starship.toml;
        };
      }
    else
      {
        ".config/aerospace" = {
          force = true;
          source = ../../cfg/macos/aerospace;
          recursive = true;
        };
        ".config/borders" = {
          force = true;
          source = ../../cfg/macos/borders;
          recursive = true;
        };
        ".config/ghostty" = {
          force = true;
          source = ../../cfg/macos/ghostty;
          recursive = true;
        };
        ".config/nixpkgs" = {
          force = true;
          source = ../../cfg/macos/nixpkgs;
          recursive = true;
        };
        ".config/skhd" = {
          force = true;
          source = ../../cfg/macos/skhd;
          recursive = true;
        };
        ".config/yabai" = {
          force = true;
          source = ../../cfg/macos/yabai;
          recursive = true;
        };
        ".config/zsh" = {
          force = true;
          source = ../../cfg/macos/zsh;
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
        ".config/starship.toml" = {
          force = true;
          source = ../../cfg/shared/starship.toml;
        };
      };

  programs.home-manager.enable = true;
}
