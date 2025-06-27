{ pkgs, inputs, ... }:
let
  isLinux = pkgs.stdenv.isLinux;
in
{
  imports = [
    ./cursor/keybindings.nix
    ./cursor/user-config.nix 
    ./cursor/extensions.nix 
  ];
  programs.vscode = {
    enable = true;
    package = if isLinux then pkgs.code-cursor-fhs else pkgs.code-cursor;
  };
}
