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
  };
  # use the latest push to the main branch for niri, comment out in case stuff breaks
  programs.niri.package = inputs.niri-unstable.packages.${pkgs.system}.niri;

  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  services.displayManager.defaultSession = lib.mkForce "niri";
}
