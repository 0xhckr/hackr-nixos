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
    wf-recorder
    slurp
    wl-clipboard
  ] ++ (with inputs; [
    swww.packages."${system}".default
    quickshell.packages."${system}".default
  ]);
}
