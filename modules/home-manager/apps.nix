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
in
{
  imports = [
    ./apps/cursor.nix
  ];
  home.packages =
    with pkgs;
    [
      spotify
      vesktop
      spacedrive
      obsidian
      fontforge
    ]
    ++ (lib.optionals isLinux [
      zoom-us
      _1password-gui
      nautilus
      element-desktop
      nordpass
      slack # slack on macOS works mostly but the items that require permissions like microphone and camera don't work
      inputs.dataflare.packages."${system}".default
      gimp
      protonmail-desktop
      parsec-bin
      ryujinx
    ])
    ++ (lib.optionals isDarwin [
      mos
      stats
      alt-tab-macos
    ])
    # ++ jetbrainsApps
    # ++ affinityApps
    ++ browsers;
}
