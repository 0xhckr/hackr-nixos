{ pkgs, lib, ... }:
{
  environment.systemPackages = [
    # For debugging and troubleshooting Secure Boot.
    pkgs.sbctl
  ];

  
  boot.loader.systemd-boot.enable = true;
}
