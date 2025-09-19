{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nur.repos.charmbracelet.crush
  ];

  nixpkgs.config.allowUnfree = true;
}