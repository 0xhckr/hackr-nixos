{ pkgs, inputs, ... }:
{

  imports = [
    inputs.ags.homeManagerModules.default
  ];

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
    astal.packages.${system}.default
  ]);

  # programs.ags = {
  #   enable = true;
  #   configDir = ../../ags;
  #   extraPackages = with pkgs; [

  #   ] ++ (with inputs.ags.packages."${system}"; [
  #     apps
  #   ]);
  # };
}
