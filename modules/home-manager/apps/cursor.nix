{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./cursor/keybindings.nix
    ./cursor/user-config.nix
    ./cursor/extensions.nix
  ];
  programs.vscode = {
    enable = true;
    package = pkgs.code-cursor-fhs;
  };
}
