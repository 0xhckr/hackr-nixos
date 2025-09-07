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
      waypaper
      waybar
      playerctl
      wlogout
      wf-recorder
      slurp
      hyprpicker
      wl-clipboard
      pavucontrol
      pulseaudioFull
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
