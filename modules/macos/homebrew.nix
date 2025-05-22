{ ... }:
{
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
      "slack" # slack needs to be installed via brew since it doesn't work via nixpkgs
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
}
