{
  pkgs,
  pkgs-fresh,
  inputs,
  system,
  ...
}: {
  imports = [
    ./ghostty.nix
  ];

  home.packages = with pkgs;
    [
      (btop.override {
        rocmSupport = true;
      })
      atuin
      lazygit
      pokeget-rs
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
    ]
    ++ (with pkgs-fresh; [
      claude-code
    ]);

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
