{pkgs-fresh, ...}: {
  services.tailscale.enable = true;
  networking.firewall.trustedInterfaces = ["tailscale0"];
  networking.firewall.checkReversePath = "loose";

  environment.systemPackages = with pkgs-fresh; [tailscale tailscale-systray];
}
