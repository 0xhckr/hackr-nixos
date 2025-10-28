{ lib, ... }:
{
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = lib.mkForce true;
      };
      grub = {
        enable = true;
        device = "nodev";
        useOSProber = true;
        efiSupport = true;
      };
    }; 
  };

  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;
}
