{
  pkgs,
  inputs,
  fullName,
  email,
  system,
  ...
}: {
  home.packages = with pkgs; [
    android-tools
    nil
    nixfmt
    gcc
    gnumake
    (inputs.fenix.packages."${system}".stable.withComponents [
      "cargo"
      "rustc"
      "rustfmt"
      "clippy"
      "rust-analyzer"
      "rust-src"
    ])
    # cargo
    bun
    biome
    jdk
    minio-client
    inputs.jj.packages."${system}".jujutsu
    inputs.jj-starship.packages."${system}".jj-starship
    inputs.gojo.packages."${system}".default
  ];

  home.file.".bun/install/global/package-original.json".text = ''
    {
      "name": "bun-global",
      "version": "1.0.0",
      "private": true
    }
  '';

  programs.git = {
    enable = true;
    lfs.enable = true;
    signing.format = null;
    settings = {
      user = {
        name = fullName;
        inherit email;
      };
    };
  };

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
  };
}
