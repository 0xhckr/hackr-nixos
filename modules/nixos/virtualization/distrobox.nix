{pkgs-stable, ...}: {
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  environment.systemPackages = with pkgs-stable; [distrobox podman-compose];
}
