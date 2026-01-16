{
  pkgs,
  ...
}: {
  imports = [
    ./keybindings.nix
    ./user-config.nix
    ./extensions.nix
  ];
  programs.vscode = {
    enable = true;
    package = pkgs.vscode-fhs;
  };

  home.packages = with pkgs; [
    zed-editor-fhs
  ];
}
