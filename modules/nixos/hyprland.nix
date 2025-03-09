{ ... }:
{
  # Enable hyprland
  programs.hyprland = {
    enable = true;
  };

  services.displayManager.defaultSession = "hyprland";
}
