{ pkgs, ... }:
{
  services.tailscale.enable = true;
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.checkReversePath = "loose";

  environment.systemPackages = with pkgs; [ tailscale tailscale-systray ];
} 