{
  config,
  pkgs,
  ...
}:

{
  virtualisation.docker.enable = true;
  users.users.hackr.extraGroups = [ "docker" ];
}
