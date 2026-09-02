{
  lib,
  pkgs,
  ...
}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      limine = {
        enable = true;
        style = {
          wallpapers = [];
          backdrop = lib.mkForce "191724";
          interface = {
            resolution = "2880x1920";
            helpHidden = true;
            branding = "";
          };
          graphicalTerminal = {
            palette = lib.mkForce "191724;eb6f92;31748f;f6c177;9ccfd8;c4a7e7;9ccfd8;e0def4";
            brightPalette = lib.mkForce "6e6a86;eb6f92;31748f;f6c177;9ccfd8;c4a7e7;9ccfd8;e0def4";
            background = lib.mkForce "191724";
            foreground = lib.mkForce "e0def4";
            brightBackground = lib.mkForce "26233a";
            brightForeground = lib.mkForce "e0def4";
          };
        };
      };
      timeout = 5;
    };
  };

  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;
}
