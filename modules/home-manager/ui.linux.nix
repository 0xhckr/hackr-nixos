{ pkgs, inputs, ... }:
{

  imports = [
    inputs.ags.homeManagerModules.default
    inputs.sherlock.homeManagerModules.default
  ];

  home.packages =
    with pkgs;
    [
      cava
      wofi
      dunst
      waypaper
      waybar
      playerctl
      wlogout
      wf-recorder
      slurp
      wl-clipboard
      pavucontrol
      alsa-utils
      swaybg
    ]
    ++ (with inputs; [
      swww.packages.${system}.default
      quickshell.packages.${system}.default
      astal.packages.${system}.default
    ]);

  programs.sherlock = {
    enable = true;
    settings = null;
  };
}
