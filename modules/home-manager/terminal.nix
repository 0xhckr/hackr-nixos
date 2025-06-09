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
      btop
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
    ++ (lib.optionals isLinux [
      inputs.ghostty.packages."${system}".default
    ]);

  programs.nushell = {
    enable = true;
    environmentVariables = config.home.sessionVariables;
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
