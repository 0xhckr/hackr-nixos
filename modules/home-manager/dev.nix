{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nil
    nixfmt-rfc-style
    python3Full
    gcc
    gnumake
    mise
    cargo
    nodejs
    bun
  ];

  programs.git = {
    enable = true;
    userName = "Mohammad Al-Ahdal";
    userEmail = "hackr@hackr.sh";
  };

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
  };
}