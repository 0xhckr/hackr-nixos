{pkgs, ...}: {
  home.packages = with pkgs; [
    android-tools
    nil
    nixfmt-rfc-style
    gcc
    gnumake
    cargo
    nodejs
    bun
    biome
    jdk
    minio-client
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Mohammad Al-Ahdal";
        email = "hackr@hackr.sh";
      };
    };
  };

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
  };
}
