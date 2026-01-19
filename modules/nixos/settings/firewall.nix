{
  ...
}: let
  allowedPorts = [
    3000
  ];
in {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = allowedPorts;
    allowedUDPPorts = allowedPorts;
  };
}
