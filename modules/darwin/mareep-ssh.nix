{
  pkgs,
  username,
  ...
}:
let
  # macOS's Remote Login launchd socket listens on every interface. Keep it
  # disabled and expose this loopback-only daemon through Tailscale Serve.
  sshdConfig = pkgs.writeText "mareep-sshd_config" ''
    HostKey /etc/ssh/ssh_host_ed25519_key
    ListenAddress 127.0.0.1
    Port 2222
    UsePAM yes
    PermitRootLogin no
    PasswordAuthentication no
    KbdInteractiveAuthentication no
    PubkeyAuthentication yes
    AllowUsers ${username}
    AuthorizedKeysFile ${../../ssh/authorized_keys}
  '';
in
{
  services.openssh.enable = false;

  launchd.daemons.mareep-sshd = {
    command = "/usr/sbin/sshd -D -e -f ${sshdConfig}";
    serviceConfig = {
      RunAtLoad = true;
      KeepAlive = true;
    };
  };

  # Tailscale Serve forwards raw TCP on the tailnet to the private SSH port.
  # Its configuration persists across reboots; retry on startup until the
  # existing macOS Tailscale app has connected to the tailnet.
  launchd.daemons.mareep-ssh-serve = {
    script = ''
      until /usr/local/bin/tailscale status > /dev/null 2>&1; do
        sleep 5
      done
      /usr/local/bin/tailscale serve --bg --tcp 22 tcp://127.0.0.1:2222
    '';
    serviceConfig = {
      UserName = username;
      RunAtLoad = true;
      KeepAlive = {
        SuccessfulExit = false;
      };
      ThrottleInterval = 30;
    };
  };
}
