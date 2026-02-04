{...}: {
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;
  services.openssh.settings.KbdInteractiveAuthentication = true;
  services.openssh.settings.PermitRootLogin = "no";
}
