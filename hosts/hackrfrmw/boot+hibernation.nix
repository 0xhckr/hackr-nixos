{ lib, ... }:
{
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = lib.mkForce true;
      };
      systemd-boot = {
        enable = lib.mkForce true;
      };
    }; 
  };

  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;
}
