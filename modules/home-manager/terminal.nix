{
  pkgs,
  inputs,
  system,
  ...
}: {
  home.packages = with pkgs; [
    (btop.override {
      rocmSupport = true;
    })
    atuin
    lazygit
    fastfetch
    fzf
    ripgrep
    bat
    gh
    nix-output-monitor
    inputs.commie.packages."${system}".default
    libnotify
    psmisc
    inputs.ghostty.packages."${system}".default
  ];

  home.file = {
    ".config/nushell/env.nu" = {
      force = true;
      text = ''
        $env.config.show_banner = false
        $env.DIRENV_LOG_FORMAT = ""
        $env.NIXPKGS_ALLOW_UNFREE = "1"
        $env.DISPLAY = ":0"
      '';
    };
  };
}
