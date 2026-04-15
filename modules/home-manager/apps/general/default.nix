{
  pkgs,
  inputs,
  system,
  pkgs-stable,
  ...
}: let
  addons = pkgs.extend inputs.firefox-addons.overlays.default;
  jetbrainsApps = with pkgs-stable.jetbrains; [
    datagrip
    rider
    rust-rover
    idea
  ];
  # NOTE: requires manual download of affinity apps.
  affinityApps = with inputs.affinity-nix.packages."${system}"; [
    v3
  ];
  browsers = with pkgs-stable; [
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
      obsidian
      fontforge
      # discord
      vesktop
      whatsapp-electron
      krisp-patcher
      zoom-us
      nautilus
      slack
      # inputs.graphite.packages."${system}".default
      inputs.helium.packages."${system}".default
      inputs.stoa.packages."${system}".default
      winboat
      gimp
      parsec-bin
      ryubing
      vlc
      yaak
      filezilla
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
      # Personal
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
        url = "https://deploy.0xhckr.dev/";
        isEssential = true;
        position = 102;
      };
      "github (personal)" = {
        id = "00000000-0000-0000-0000-000000000003";
        container = containers.personal.id;
        url = "https://github.com/";
        isEssential = true;
        position = 103;
      };
      "0xhckr.dev" = {
        id = "00000000-0000-0000-0000-000000000004";
        container = containers.personal.id;
        url = "https://0xhckr.dev/";
        isEssential = true;
        position = 104;
      };

      # Work
      "github (work)" = {
        id = "00000000-0000-0000-0000-000000000005";
        container = containers.werk.id;
        url = "https://github.com/";
        isEssential = true;
        position = 201;
      };
      "outlook (work)" = {
        id = "00000000-0000-0000-0000-000000000006";
        container = containers.werk.id;
        url = "https://outlook.cloud.microsoft/";
        isEssential = true;
        position = 202;
      };
      "teams" = {
        id = "00000000-0000-0000-0000-000000000007";
        container = containers.werk.id;
        url = "https://teams.cloud.microsoft/";
        isEssential = true;
        position = 203;
      };
      "jira" = {
        id = "00000000-0000-0000-0000-000000000008";
        container = containers.werk.id;
        url = "https://knowhistory.atlassian.net/jira/people/712020%3A201746e7-e3ca-4634-85bc-c7b1c68b2ea7/boards/7";
        isEssential = true;
        position = 204;
      };
      "coolify" = {
        id = "00000000-0000-0000-0000-000000000009";
        container = containers.werk.id;
        url = "https://coolify.hstry.dev/";
        isEssential = true;
        position = 205;
      };
      "coolify-mno-pr" = {
        id = "00000000-0000-0000-0000-00000000000a";
        container = containers.werk.id;
        url = "https://mno-coolify.hstry.dev/";
        isEssential = true;
        position = 206;
      };
      "azuredevops" = {
        id = "00000000-0000-0000-0000-00000000000b";
        container = containers.werk.id;
        url = "https://portal.azure.com/";
        isEssential = true;
        position = 207;
      };

      # Skewl
      "my-ucalgary" = {
        id = "00000000-0000-0000-0000-00000000000c";
        container = containers.skewl.id;
        url = "https://my.ucalgary.ca/";
        isEssential = true;
        position = 301;
      };
      "outlook (school)" = {
        id = "00000000-0000-0000-0000-00000000000d";
        container = containers.skewl.id;
        url = "https://outlook.cloud.microsoft/";
        isEssential = true;
        position = 302;
      };
      "d2l" = {
        id = "00000000-0000-0000-0000-00000000000e";
        container = containers.skewl.id;
        url = "https://d2l.ucalgary.ca/";
        isEssential = true;
        position = 303;
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
    keyboardShortcutsVersion = 17;
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
      extensions.packages = with addons.firefox-addons; [
        ublock-origin
        darkreader
        onepassword-password-manager
      ];

      inherit containers spaces pins keyboardShortcuts keyboardShortcutsVersion;
    };
  };

  # Zen-browser stylix target configuration
  # Theme settings are inherited from NixOS-level stylix configuration
  stylix.targets.zen-browser.profileNames = ["default"];
}
