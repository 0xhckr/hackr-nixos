{
  pkgs,
  inputs,
  system,
  ...
}: let
  jetbrainsApps = with pkgs.jetbrains; [
    datagrip
    rider
    rust-rover
    idea
  ];
  # NOTE: requires manual download of affinity apps.
  affinityApps = with inputs.affinity-nix.packages."${system}"; [
    v3
  ];
  browsers = with pkgs; [
    ungoogled-chromium
    firefox
  ];
  krisp-patcher =
    pkgs.writers.writePython3Bin "krisp-patcher"
    {
      libraries = with pkgs.python3Packages; [
        capstone
        pyelftools
      ];
      flakeIgnore = [
        "E501" # line too long (82 > 79 characters)
        "F403" # 'from module import *' used; unable to detect undefined names
        "F405" # name may be undefined, or defined from star imports: module
      ];
    }
    (
      builtins.readFile (
        pkgs.fetchurl {
          url = "https://pastebin.com/raw/8tQDsMVd";
          sha256 = "sha256-IdXv0MfRG1/1pAAwHLS2+1NESFEz2uXrbSdvU9OvdJ8=";
        }
      )
    );
in {
  imports = [
    inputs._1password.hmModules.default
    inputs.zen-browser.homeModules.twilight
    ../editor
    ../helix
  ];
  home.packages = with pkgs;
    [
      spotify
      obsidian
      fontforge
      discord
      whatsapp-electron
      krisp-patcher
      zoom-us
      nautilus
      slack
      inputs.graphite.packages."${system}".default
      winboat
      gimp
      protonmail-desktop
      parsec-bin
      ryubing
      vlc
      yaak
    ]
    ++ jetbrainsApps
    ++ affinityApps
    ++ browsers;

  # needed for vicinae to properly launch x apps in niri
  systemd.user.settings.Manager.DefaultEnvironment = {
    DISPLAY = ":0";
    XAUTHORITY = "$HOME/.Xauthority";
  };

  programs._1password-shell-plugins = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
  };

  programs.zen-browser = let
    containers = {
      personal = {
        color = "purple";
        icon = "fingerprint";
        id = 1;
      };
      werk = {
        color = "blue";
        icon = "briefcase";
        id = 2;
      };
      skewl = {
        color = "yellow";
        icon = "briefcase";
        id = 3;
      };
    };
    spaces = {
      "personal" = {
        id = "00000000-0000-0000-0000-000000000010";
        icon = "👾";
        container = containers.personal.id;
        position = 1000;
      };
      "werk" = {
        id = "00000000-0000-0000-0000-000000000011";
        icon = "🏢";
        container = containers.werk.id;
        position = 2000;
      };
      "skewl" = {
        id = "00000000-0000-0000-0000-000000000012";
        icon = "🎓";
        container = containers.skewl.id;
        position = 3000;
      };
    };
    pins = {
      # NOTE: Pins are not currently working: https://github.com/0xc000022070/zen-browser-flake/issues/201
      "mail" = {
        id = "00000000-0000-0000-0000-000000000001";
        container = containers.personal.id;
        url = "https://mail.proton.me/inbox";
        isEssential = true;
        position = 101;
      };
      "dokploy" = {
        id = "00000000-0000-0000-0000-000000000002";
        container = containers.personal.id;
        url = "https://dokploy.alahdal.ca/";
        isEssential = true;
        position = 102;
      };
    };
    keyboardShortcuts = [
      # Change compact mode toggle to Ctrl+Alt+S
      {
        id = "zen-compact-mode-toggle";
        key = "s";
        modifiers = {
          control = true;
        };
      }
    ];
    # Fails activation on schema changes to detect potential regressions
    # Find this in about:config or prefs.js of your profile
    keyboardShortcutsVersion = 14;
  in {
    enable = true;
    policies = {
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };
    profiles."default" = {
      containersForce = true;
      spacesForce = true;
      pinsForce = true;

      inherit containers spaces pins keyboardShortcuts keyboardShortcutsVersion;
    };
  };

  # Zen-browser stylix target configuration
  # Theme settings are inherited from NixOS-level stylix configuration
  stylix.targets.zen-browser.profileNames = [ "default" ];

}
