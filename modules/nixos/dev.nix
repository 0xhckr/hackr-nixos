{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nur.repos.charmbracelet.crush
  ];
}