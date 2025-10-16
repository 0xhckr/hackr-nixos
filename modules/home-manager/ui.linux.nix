{ pkgs, inputs, ... }:
{

  imports = [
    inputs.ags.homeManagerModules.default
    inputs.vicinae.homeManagerModules.default
    # inputs.dms.homeModules.dankMaterialShell.default
    # inputs.dms.homeModules.dankMaterialShell.niri
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

  # programs.dankMaterialShell.enable = true;

  services.vicinae = {
    enable = true;
    autoStart = true;
  };
}
