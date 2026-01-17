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

  home.packages = with pkgs; [
    zed-editor-fhs
  ];
}
