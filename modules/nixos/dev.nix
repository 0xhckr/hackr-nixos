{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nur.repos.charmbracelet.crush
  ];

  users.defaultUserShell = pkgs.nushell;

  nixpkgs.config.allowUnfree = true;
}