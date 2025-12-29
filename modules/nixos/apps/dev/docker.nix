{
  config,
  pkgs,
  ...
}: {
  virtualisation.docker = {
    enable = true;
  };
  users.users.hackr.extraGroups = ["docker"];

  environment.systemPackages = with pkgs; [
    # dive
    # podman-tui
    # podman-compose
    docker-compose
  ];

  boot.kernelModules = ["ip_tables" "iptable_nat"];
}
