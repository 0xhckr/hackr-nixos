
{ pkgs, ... }:
let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  # temporary disable imports for darwin
  imports = [
    ./ssh.nix
    # ./terminal.nix
    # ./ui.nix
    # ./apps.nix
    # ./dev.nix
  ];

  home.username = "hackr";
  home.homeDirectory = if isLinux then "/home/hackr" else "/Users/hackr";

  home.stateVersion = "24.11";
  nixpkgs.config.allowUnfree = true;

  home.file = if isLinux then {
    ".config/" = {
      force = true;
      source = ../../cfg;
      recursive = true;
    };
  } else {
    ".config/" = {
      force = true;
      source = ../../macos-cfg;
      recursive = true;
    };
  };

  programs.home-manager.enable = true;
}
