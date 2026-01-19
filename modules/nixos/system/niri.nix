{
  pkgs,
  lib,
  inputs,
  system,
  ...
}: {
  # Enable Niri
  programs.niri = {
    enable = true;
    # package = pkgs.niri;
    package = inputs.niri-blurry.packages.${system}.niri;
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  services.displayManager.defaultSession = lib.mkForce "niri";
}
