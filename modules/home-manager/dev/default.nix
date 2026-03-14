{pkgs, inputs, fullName, email, system, ...}: {
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
    inputs.jj.packages."${system}".jujutsu
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;
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
