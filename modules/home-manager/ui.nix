{ pkgs, inputs, lib, ... }:
{

  imports = [
    inputs.vicinae.homeManagerModules.default
  ];

  home.packages =
    with pkgs;
    [
      cava
      playerctl
      brightnessctl
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
