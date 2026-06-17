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
      # Docker on macOS via colima (FOSS Lima VM) + the docker CLI, instead of
      # Docker Desktop. docker-compose provides the `docker compose` plugin.
      # Wiring (compose plugin symlink + colima autostart) is in home/docker.nix.
      "colima"
      "docker"
      "docker-compose"
      "fastfetch"
      "jj"
      "nushell"
      "zoxide"
    ];

    casks = [
      "1password"
      # Font used by ghostty (see home/ghostty.nix); matches the NixOS config.
      "font-departure-mono-nerd-font"
      "ghostty"
      # Loop — radial-menu window manager (github.com/MrKai77/Loop).
      "loop"
      "nordpass"
      "raycast"
      "zed"
      "zen"
    ];
  };
}
