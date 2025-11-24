{ pkgs, lib, ... }:
{
  imports = [
    ../../modules/nixos/unified-boot.nix
  ];

  boot.loader.limine = {
    secureBoot.enable = true;
    style.interface.resolution = "5120x2160";
  };
}
