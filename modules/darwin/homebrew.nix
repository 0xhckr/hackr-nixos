# Homebrew-managed packages. Per preference, install software from Homebrew
# where available and declare it here for reproducibility; the tools' configs
# are managed by home-manager (see ./home). Homebrew itself must already be
# installed — this module only drives `brew bundle`, it doesn't bootstrap brew.
{...}: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      # Additive: won't uninstall brews you added by hand. Switch to
      # "uninstall" / "zap" once everything you want is declared here.
      cleanup = "none";
    };

    brews = [
      "btop"
      "fastfetch"
      "jj"
      "nushell"
    ];

    casks = [
      "1password"
      "ghostty"
      "nordpass"
      "raycast"
      "zed"
      "zen"
    ];
  };
}
