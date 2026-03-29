{pkgs-stable, ...}: {
  services.flatpak = {
    enable = true;
    package = pkgs-stable.flatpak;
  };
}
