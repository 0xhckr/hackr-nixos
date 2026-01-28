{
  imports = [
    ./dev
    ./games
    ./libre-office.nix
    ./netbird.nix
    ./obs.nix
    ./tailscale.nix
  ];

  # THIS FEELS SO WRONG.
  services.flatpak.enable = true;
}
