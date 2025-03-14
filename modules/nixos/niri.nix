{ pkgs, ... }:
{
  # Enable Niri
  programs.niri = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  services.displayManager.defaultSession = "niri";
}
