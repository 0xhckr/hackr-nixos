{ pkgs, lib, ... }:
{
  environment.systemPackages = [
    # For debugging and troubleshooting Secure Boot.
    pkgs.sbctl
  ];
  imports = [
    ../../modules/nixos/unified-boot.nix
  ];

  boot.loader.limine.style.interface.resolution = "3840x2160";
}
