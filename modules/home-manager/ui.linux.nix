{ pkgs, inputs, lib, ... }:
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
      brightnessctl
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
      awww.packages.${system}.default
      quickshell.packages.${system}.default
      astal.packages.${system}.default
      caelestia.packages.${system}.default
      noctalia.packages.${system}.default
    ]);

  # programs.dankMaterialShell.enable = true;

  services.vicinae = {
    enable = true;
    autoStart = true;
  };

  systemd.user.services.vicinae = {
    Service.Environment = lib.mkForce [ "USE_LAYER_SHELL=0" ];
    Service.EnvironmentFile = lib.mkForce [];
  };
}
