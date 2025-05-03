{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    wofi
    dunst
    waypaper
    waybar
    cava
    playerctl
    wlogout
  ] ++ (with inputs; [
    swww.packages."${system}".default
    quickshell.packages."${system}".default
  ]);
}
