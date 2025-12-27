{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    satisfactorymodmanager
  ];
}