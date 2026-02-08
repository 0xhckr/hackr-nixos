{
  pkgs,
  inputs,
  system,
  lib,
  ...
}: {
  imports = [
    inputs.vicinae.homeManagerModules.default
  ];

  home.packages = with pkgs;
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
      wlsunset
    ]
    ++ (with inputs; [
      awww.packages.${system}.default
      noctalia.packages.${system}.default
    ]);

  programs.vicinae = {
    enable = true;
    settings = {
      launcher_window.layer_shell.enabled = false;
      launcher_window.opacity = 1.0;
      theme.dark.name = "stylix";
      theme.light.name = "stylix";
    };
    systemd = {
      enable = true;
      autoStart = true;
    };
  };

  # TODO: control wlsunset using a script instead of a service so it can be disabled and enabled as needed
  services.wlsunset = {
    enable = true;
    gamma = 0.8;
    latitude = 51.0447;
    longitude = -114.0719;
    package = pkgs.wlsunset;
  };
}
