{
  pkgs-stable,
  lib,
  inputs,
  system,
  ...
}: {
  # Enable Niri
  programs.niri = {
    enable = true;
    # package = pkgs.niri;
    package = inputs.niri.packages.${system}.niri;
  };

  environment.systemPackages = with pkgs-stable; [
    xwayland-satellite
  ];

  services.displayManager.defaultSession = lib.mkForce "niri";
}
