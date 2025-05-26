{ pkgs, inputs, ... }:
let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
in
{

  imports = [
    inputs.ags.homeManagerModules.default
    inputs.sherlock.homeManagerModules.default
  ];

  home.packages =
    with pkgs;
    [
      cava
    ]
    ++ (lib.optionals isLinux [
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
      swaybg
    ])
    ++ (lib.optionals isLinux (
      with inputs;
      [
        swww.packages.${system}.default
        quickshell.packages.${system}.default
        astal.packages.${system}.default
      ]
    ));

  programs.sherlock = {
    enable = true;
    settings = null;
  };
}
