{
  self,
  pkgs,
  inputs,
  ...
}:
{
  system.primaryUser = "hackr";

  imports = [
    ../../modules/nixos/user-cfg.nix
  ];

  environment.variables = {
    ZDOTDIR = "$HOME/.config/zsh";
    XDG_CONFIG_HOME = "$HOME/.config";
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

  programs.zsh = {
    enable = true;
    enableBashCompletion = true;
    enableCompletion = true;
    enableFzfCompletion = true;
    enableFzfGit = true;
    enableFzfHistory = true;
    enableSyntaxHighlighting = true;
  };

  # system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts._0xproto
    nerd-fonts.departure-mono
    (google-fonts.override {
      fonts = [
        "DM Sans"
        "DM Mono"
        "DM Serif Display"
        "DM Sans Display"
        "Cairo"
        "Zain"
      ];
    })
  ];

  security.pam.services.sudo_local.touchIdAuth = true;

  homebrew = {
    enable = true;
    brews = [
      "azure-cli" # we install az via brew since az ssh is broken on pkgs.azure-cli
      "mise"
      "cocoapods"
      "nsis"
      "llvm"
    ];

    # all mas apps install super slowly. Document them here but install them manually
    masApps = {
      # "Hand Mirror" = 1502839586;
      # "Amphetamine" = 937984704;
      # "Xcode" = 497799835;
    };

    casks = [
      "proton-pass"
      "proton-mail"
      "protonvpn"
      "proton-drive"
      "nikitabobko/tap/aerospace"
      "arc"
      "1password"
      "docker"
      "microsoft-outlook"
      "sip"
      "bluebubbles"
      "tableplus"
      "twingate"
      "kicad"
      "bartender"
      "jetbrains-toolbox"
      "rider"
      "visual-studio-code"
      "zed"
      "ghostty"
      "zen-browser"
      {
        name = "raycast";
        greedy = true;
      }
      "loop"
      "discord"
    ];
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
}
