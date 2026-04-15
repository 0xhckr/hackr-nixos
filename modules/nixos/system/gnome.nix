{...}: {
  services.xserver.enable = true;
  services.displayManager.gdm.enable = false;
  services.desktopManager.gnome.enable = true;

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
