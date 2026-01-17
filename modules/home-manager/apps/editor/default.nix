{pkgs, ...}: {
  imports = [
    ./language-servers.nix
    # TODO: remove all references to vscode in favour of zed-editor-fhs
    # ./keybindings.nix
    # ./user-config.nix
    # ./extensions.nix
  ];
  # programs.vscode = {
  #   enable = true;
  #   package = pkgs.vscode-fhs;
  # };

  programs.zed-editor = {
    enable = true;
    package =
      pkgs.zed-editor.fhsWithPackages
      (
        pkgs:
          with pkgs; [
            openssl
            zlib
            libz
          ]
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
