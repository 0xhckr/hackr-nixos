{
  config,
  pkgs,
  ...
}:

{
  virtualisation.podman.enable = true;
  users.users.hackr.extraGroups = [ "docker" ];
}
