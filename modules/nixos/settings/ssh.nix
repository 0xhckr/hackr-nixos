_: {
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = true;
      PermitRootLogin = "no";
      # Allow a reconnecting Mac to replace a stale forwarded agent socket.
      StreamLocalBindUnlink = true;
    };
  };
}
