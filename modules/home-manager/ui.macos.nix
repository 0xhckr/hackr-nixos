{ pkgs, inputs, ... }:
let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  home.packages = with pkgs; [
    cava
  ];
}
