{ pkgs, inputs, system, ... }:
let
  jetbrainsApps = with pkgs.jetbrains; [
    datagrip
    rider
    rust-rover
  ];
  # NOTE: requires manual download of affinity apps.
  affinityApps = with inputs.affinity-nix.packages."${system}"; [
    designer
  ];
  browsers =
    with pkgs;
    [
      microsoft-edge
      ungoogled-chromium
    ]
    ++ (with inputs; [
      zen-browser.packages."${system}".default
    ]);
in
{
  home.packages =
    with pkgs;
    [
      spotify
      vesktop
      _1password-gui
      slack
      code-cursor
      nautilus
      element-desktop
      zoom-us
      spacedrive
      nordpass
      ulauncher
    ]
    ++ jetbrainsApps
    ++ affinityApps
    ++ browsers;
}
