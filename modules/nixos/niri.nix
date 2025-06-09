{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  # Enable Niri
  programs.niri = {
    enable = true;
    # package = pkgs.niri;
    package = inputs.niri-blurry.packages.${pkgs.system}.niri;
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  services.displayManager.defaultSession = lib.mkForce "niri";
}
