{...}: let
  allowedPorts = [
    3000
    8081
  ];
in {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = allowedPorts;
    allowedUDPPorts = allowedPorts;
  };
}
