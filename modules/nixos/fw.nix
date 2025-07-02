{
  config,
  pkgs,
  ...
}:

{
  networking.firewall.enable = true;
  # networking.firewall.allowedTCPPorts = [ ];
  # networking.firewall.allowedUDPPorts = [ ];
}