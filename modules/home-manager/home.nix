{
  config,
  pkgs,
  inputs,
  system,
  ...
}:
{
  home.username = "hackr";
  home.homeDirectory = "/home/hackr";
  home.shell.enableNushellIntegration = true;
  imports = [
    ./ssh.nix
    ./terminal.nix
    ./ui.nix
    ./apps.nix
    ./dev.nix
  ];

  home.stateVersion = "24.11";

  nixpkgs.config.allowUnfree = true;

  home.file = {
    ".config/" = {
      force = true;
      source = ../../cfg;
      recursive = true;
    };
    ".config/nushell/env.nu" = {
      force = true;
      text = ''
        $env.config.show_banner = false
        $env.DIRENV_LOG_FORMAT = ""
        $env.NIXPKGS_ALLOW_UNFREE = "1"
      '';
    };
  };

  programs.home-manager.enable = true;

  programs.nushell = {
    enable = true;
    environmentVariables = config.home.sessionVariables;
  };
}

