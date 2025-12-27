{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    crush
  ];

  users.defaultUserShell = pkgs.nushell;

  nixpkgs.config.allowUnfree = true;
}