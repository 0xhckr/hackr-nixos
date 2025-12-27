{
  pkgs,
  inputs,
  system,
  lib,
  ...
}:
let
  jetbrainsApps =
    with pkgs.jetbrains;
    [
      datagrip
      rider
      rust-rover
      idea-ultimate
    ];
  # NOTE: requires manual download of affinity apps.
  affinityApps =
    with inputs.affinity-nix.packages."${system}";
    [
      v3
    ];
  browsers =
    with pkgs;
    [
      ungoogled-chromium
      firefox
      inputs.zen-browser.packages."${system}".default
    ];
  krisp-patcher =
    pkgs.writers.writePython3Bin "krisp-patcher"
      {
        libraries = with pkgs.python3Packages; [
          capstone
          pyelftools
        ];
        flakeIgnore = [
          "E501" # line too long (82 > 79 characters)
          "F403" # 'from module import *' used; unable to detect undefined names
          "F405" # name may be undefined, or defined from star imports: module
        ];
      }
      (
        builtins.readFile (
          pkgs.fetchurl {
            url = "https://pastebin.com/raw/8tQDsMVd";
            sha256 = "sha256-IdXv0MfRG1/1pAAwHLS2+1NESFEz2uXrbSdvU9OvdJ8=";
          }
        )
      );
in
{
  imports = [
    inputs._1password.hmModules.default
    ./apps/cursor.nix
  ];
  home.packages =
    with pkgs;
    [
      spotify
      spacedrive
      obsidian
      fontforge
      discord # discord now works flawlessly on NixOS. no need for vesktop.
      whatsapp-electron
      krisp-patcher
      zoom-us
      nautilus
      element-desktop
      nordpass
      slack
      # inputs.graphite.packages."${system}".default
      winboat
      gimp
      protonmail-desktop
      parsec-bin
      ryubing
      vlc
      requestly
    ]
    ++ jetbrainsApps
    ++ affinityApps
    ++ browsers;

    # needed for vicinae to properly launch x apps in niri
    systemd.user.settings.Manager.DefaultEnvironment = {
      DISPLAY = ":0";
      XAUTHORITY = "$HOME/.Xauthority";
    };

    programs._1password-shell-plugins = {
      enable = true;
    };

    programs.zsh = {
      enable = true;
    };
}
