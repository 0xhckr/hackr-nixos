{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.limine.enable = true;
  };

  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;
}
