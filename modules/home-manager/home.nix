{
  config,
  pkgs,
  inputs,
  system,
  ...
}:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "hackr";
  home.homeDirectory = "/home/hackr";
  home.shell.enableNushellIntegration = true;
  imports = [
    ./ssh.nix
  ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    ghostty
    wofi
    nil
    nixfmt-rfc-style
    spotify
    vesktop
    dunst
    btop
    _1password-gui
    inputs.zen-browser.packages."${system}".default
    atuin
    python3Full
    gcc
    gnumake
    mise
    cargo
    fastfetch
    starship
    zoxide
    slack
    code-cursor
    neovim
    nodejs
    bun
    nautilus
    element-desktop
    waypaper
    inputs.swww.packages."${system}".default
    waybar
    inputs.affinity-nix.packages."${system}".designer # note you need to manually download and load the affinity designer setup exe
    zoom-us
    jetbrains.datagrip
    jetbrains.rider
    jetbrains.rust-rover
    spacedrive
    cava
    playerctl
    wlogout
    microsoft-edge
    inputs.quickshell.packages."${system}".default
    ungoogled-chromium
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

