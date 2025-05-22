{ ... }:
{
  environment.variables = {
    ZDOTDIR = "$HOME/.config/zsh";
    XDG_CONFIG_HOME = "$HOME/.config";
  };

  system.defaults = {
    ".GlobalPreferences" = {
      "com.apple.mouse.scaling" = 0.5;
      # "com.apple.mouse.linear" = true; # does not work yet
    };
    NSGlobalDomain = {
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
    };

    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      CreateDesktop = false;
    };
    dock = {
      show-recents = false;
      static-only = true;
      autohide = true;
    };
    WindowManager.StandardHideDesktopIcons = true;
  };

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;
  };

  nix = {
    enable = true;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  security.pam.services.sudo_local.touchIdAuth = true;
}
