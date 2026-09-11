_: let
  allowedPorts = [
    3000
    8081
    49374
  ];
in {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = allowedPorts;
    allowedUDPPorts = allowedPorts;
  };
}
