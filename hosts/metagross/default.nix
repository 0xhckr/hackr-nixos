# MacBook Pro (M2 Max). macOS / nix-darwin host.
# Intentionally minimal: shared darwin base + home-manager for dotfiles.
{...}: {
  imports = [
    ../../modules/darwin
  ];

  networking.hostName = "metagross";
  networking.computerName = "metagross";

  # Used by `darwin-rebuild` for stateful defaults. Bump only after reading
  # the nix-darwin changelog. Unlike NixOS this is an integer, not a string.
  system.stateVersion = 6;
}
