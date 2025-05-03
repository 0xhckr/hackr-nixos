{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ghostty
    btop
    atuin
    fastfetch
    starship
    zoxide
    neovim
  ];
}
