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

  services.vicinae = {
    enable = true;
    settings = lib.mkForce {
      launcher_window = {
        opacity = 0.75;
        theme = {
          dark = {
            name = "stylix";
          };
          light = {
            name = "stylix";
          };
        };
      };
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
