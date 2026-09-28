# Mac Mini (M4). macOS / nix-darwin host.
# Intentionally minimal: shared darwin base + home-manager for dotfiles.
{ ... }: {
  imports = [
    ../../modules/darwin
    ../../modules/darwin/mareep-ssh.nix
  ];

  networking.hostName = "mareep";
  networking.computerName = "mareep";

  power = {
    sleep.computer = "never";
    restartAfterPowerFailure = true;
    restartAfterFreeze = true;
  };

  # Used by `darwin-rebuild` for stateful defaults. Bump only after reading
  # the nix-darwin changelog. Unlike NixOS this is an integer, not a string.
  system.stateVersion = 6;
}
