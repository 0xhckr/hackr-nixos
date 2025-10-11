{
  pkgs,
  inputs,
  system,
  lib,
  ...
}:
let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
  jetbrainsApps =
    with pkgs.jetbrains;
    [
      datagrip
      rider
      rust-rover
    ]
    ++ (lib.optionals isLinux [
      # any linux specific apps
    ])
    ++ (lib.optionals isDarwin [
      # any darwin specific apps
    ]);
  # NOTE: requires manual download of affinity apps.
  affinityApps =
    with inputs.affinity-nix.packages."${system}";
    [
    ]
    ++ (lib.optionals isLinux [
      designer
    ]);
  browsers =
    with pkgs;
    [
    ]
    ++ (lib.optionals isLinux [
      ungoogled-chromium
      firefox
    ])
    ++ (lib.optionals isLinux (
      with inputs;
      [
        zen-browser.packages."${system}".default
      ]
    ));
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
      krisp-patcher
    ]
    ++ (lib.optionals isLinux [
      zoom-us
      _1password-gui
      nautilus
      element-desktop
      nordpass
      slack # slack on macOS works mostly but the items that require permissions like microphone and camera don't work
      inputs.dataflare.packages."${system}".default
      inputs.winboat.packages."${system}".winboat
      gimp
      protonmail-desktop
      parsec-bin
      ryubing
      vlc
    ])
    ++ (lib.optionals isDarwin [
      mos
      stats
      alt-tab-macos
    ])
    # ++ jetbrainsApps
    # ++ affinityApps
    ++ browsers;

    # needed for vicinae to properly launch x apps in niri
    systemd.user.settings.Manager.DefaultEnvironment = {
      DISPLAY = ":0";
      XAUTHORITY = "$HOME/.Xauthority";
    };
}
