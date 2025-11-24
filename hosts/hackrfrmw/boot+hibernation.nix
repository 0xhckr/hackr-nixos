{ lib, pkgs, ... }:
{
  imports = [
    ../../modules/nixos/unified-boot.nix
  ];
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
  };

  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;

  boot.loader.limine.style.interface.resolution = "2880x1920";
}
