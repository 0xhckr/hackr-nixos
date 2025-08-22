{
  config,
  pkgs,
  inputs,
  system,
  ...
}:
let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  home.shell.enableNushellIntegration = true;

  home.packages =
    with pkgs;
    [
      (btop.override {
        rocmSupport = true;
      })
      atuin
      starship
      zoxide
      neovim
      lazygit
      vim
      screenfetch
      neofetch
      fastfetch
      fzf
      ripgrep
      bat
      zsh-autoenv
      gh
      yazi
    ]
    ++ (lib.optionals isLinux (
      with pkgs;
      [
        psmisc
        inputs.ghostty.packages."${system}".default
      ]
    ));

  programs.nushell = {
    enable = true;
    environmentVariables = config.home.sessionVariables;
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    extraConfig = ''
      set -g allow-passthrough on
      set -g default-terminal "xterm-256color"

      set -as terminal-overrides ",ghostty*:RGB,hyperlinks,graphics"
      set -as terminal-overrides ",xterm-256color:RGB"

      unbind C-b
      set -g prefix C-a

      bind-key t new-window
      bind-key - split-window -h
      bind-key | split-window -v
      bind-key w kill-pane
      bind-key q kill-server
      bind-key d detach
      bind-key r source-file ~/.config/tmux/tmux.conf
    '';
  };

  home.file =
    if isLinux then
      {
        ".config/nushell/env.nu" = {
          force = true;
          text = ''
            $env.config.show_banner = false
            $env.DIRENV_LOG_FORMAT = ""
            $env.NIXPKGS_ALLOW_UNFREE = "1"
          '';
        };
      }
    else
      {
        "Library/Application Support/nushell/env.nu" = {
          force = true;
          text = ''
            $env.ANDROID_HOME = "/Users/hackr/Library/Android/sdk"
            $env.config.show_banner = false
            $env.LDFLAGS = "-L/opt/homebrew/opt/llvm/lib"
            $env.CPPFLAGS = "-I/opt/homebrew/opt/llvm/include"
            $env.NIXPKGS_ALLOW_UNFREE = "1"
            $env.DIRENV_LOG_FORMAT = ""
            $env.XDG_CONFIG_HOME = "/Users/hackr/.config"
          '';
        };
      };
}
