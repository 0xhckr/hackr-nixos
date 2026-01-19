{
  pkgs,
  inputs,
  system,
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
    ]
    ++ (with inputs; [
      awww.packages.${system}.default
      noctalia.packages.${system}.default
    ]);

  services.vicinae = {
    enable = true;
  };
}
