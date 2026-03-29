{
  pkgs,
  inputs,
  system,
  ...
}: {
  imports = [
    ./niri.nix
    ./noctalia.nix
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
}
