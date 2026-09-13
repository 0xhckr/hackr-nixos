{pkgs-fresh, username, ...}: {
  services.tailscale.enable = true;
  services.tailscale.extraSetFlags = ["--operator=${username}"];
  networking.firewall.trustedInterfaces = ["tailscale0"];
  networking.firewall.checkReversePath = "loose";

  environment.systemPackages = with pkgs-fresh; [tailscale tailscale-systray];
}
