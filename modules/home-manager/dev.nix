{ pkgs, ... }:
{
  home.packages = with pkgs; [
    android-tools
    nil
    nixfmt-rfc-style
    gcc
    gnumake
    mise
    cargo
    nodejs
    bun
    biome
    jdk
    minio-client
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
