{ config, pkgs, ... }:
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
    ]
    ++ (lib.optionals isLinux [
      ghostty
    ]);

  programs.nushell = {
    enable = true;
    environmentVariables = config.home.sessionVariables;
  };

  home.file = {
    ".config/nushell/env.nu" =
      if isLinux then
        {
          force = true;
          text = ''
            $env.config.show_banner = false
            $env.DIRENV_LOG_FORMAT = ""
            $env.NIXPKGS_ALLOW_UNFREE = "1"
          '';
        }
      else
        {
          force = true;
          text = ''
            $env.ANDROID_HOME = "/Users/hackr/Library/Android/sdk"
            $env.config.show_banner = false
            $env.LDFLAGS = "-L/opt/homebrew/opt/llvm/lib"
            $env.CPPFLAGS = "-I/opt/homebrew/opt/llvm/include"
            $env.NIXPKGS_ALLOW_UNFREE = "1"
            $env.DIRENV_LOG_FORMAT = ""
          '';
        };
  };
}
