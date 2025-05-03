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
  ];

  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    nil
    nixfmt-rfc-style
    python3Full
    gcc
    gnumake
    mise
    cargo
    nodejs
    bun
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Mohammad Al-Ahdal";
    userEmail = "hackr@hackr.sh";
  };

  programs.nushell = {
    enable = true;
    environmentVariables = config.home.sessionVariables;
  };

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
  };
}

