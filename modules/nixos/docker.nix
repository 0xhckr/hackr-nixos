{
  config,
  pkgs,
  ...
}:

{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  users.users.hackr.extraGroups = [ "docker" ];

  environment.systemPackages = with pkgs; [
    dive
    podman-tui
    podman-compose
  ];
}
