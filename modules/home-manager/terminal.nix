{ config, pkgs, ... }:
{
  home.shell.enableNushellIntegration = true;

  home.packages = with pkgs; [
    ghostty
    btop
    atuin
    fastfetch
    starship
    zoxide
    neovim
  ];

  programs.nushell = {
    enable = true;
    environmentVariables = config.home.sessionVariables;
  };

  home.file = {
    ".config/nushell/env.nu" = {
      force = true;
      text = ''
        $env.config.show_banner = false
        $env.DIRENV_LOG_FORMAT = ""
        $env.NIXPKGS_ALLOW_UNFREE = "1"
      '';
    };
  };
}
