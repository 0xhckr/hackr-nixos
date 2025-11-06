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
    package = inputs.niri-unstable.packages.${pkgs.system}.niri;
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite
    # material-symbols
    # inter
    # fira-code
  ];

  services.displayManager.defaultSession = lib.mkForce "niri";
}
