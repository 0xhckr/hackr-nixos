{ pkgs, inputs, ... }:
{

  imports = [
    inputs.ags.homeManagerModules.default
    inputs.gauntlet.homeManagerModules.default
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
    swaybg
  ] ++ (with inputs; [
    swww.packages."${system}".default
    quickshell.packages."${system}".default
    astal.packages.${system}.default
  ]);

  programs.gauntlet = {
    enable = true;
    service.enable = true;
    config = { };
  };
}
