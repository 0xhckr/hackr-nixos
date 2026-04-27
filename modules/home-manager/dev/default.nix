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
    inputs.jj.packages."${system}".jujutsu
    inputs.helios.packages."${system}".default
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;
    signing.format = null;
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
