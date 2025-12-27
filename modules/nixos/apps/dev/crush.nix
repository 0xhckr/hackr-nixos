{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    crush
  ];
  nixpkgs.config.allowUnfree = true;
}