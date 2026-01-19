{pkgs, ...}: let
  extensionDependencies = with pkgs; [
    openssl
    zlib
  ];
in {
  imports = [
    ./language-servers.nix
  ];

  # We add extension specific dependencies so they show up when
  # zed is launched via the terminal and also when it's launched
  # using an app launcher
  home.packages = [] ++ extensionDependencies;

  programs.zed-editor = {
    enable = true;
    package =
      pkgs.zed-editor.fhsWithPackages
      (
        pkgs: [] ++ extensionDependencies
      );
    extensions = [
      "catppuccin-icons"
      "discord-presence"
      "ghostty"
      "html"
      "java"
      "nix"
      "prisma"
      "sql"
      "toml"
    ];
  };
}
