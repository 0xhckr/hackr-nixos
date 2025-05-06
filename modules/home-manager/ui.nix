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
    pavucontrol
  ] ++ (with inputs; [
    swww.packages."${system}".default
    quickshell.packages."${system}".default
  ]);
}
