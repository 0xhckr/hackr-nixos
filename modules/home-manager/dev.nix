{pkgs, username, fullName, email, ...}: {
  home.packages = with pkgs; [
    android-tools
    nil
    nixfmt
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
        name = fullName;
        email = email;
      };
    };
  };

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
  };
}
