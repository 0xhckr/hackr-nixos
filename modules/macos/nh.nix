{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nh
  ];
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 3d --keep 3";
    flake = "/Users/hackr/nixos";
  };
}