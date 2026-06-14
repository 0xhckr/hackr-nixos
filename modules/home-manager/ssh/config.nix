{username, ...}: {
  home.file.".ssh/config" = {
    text = ''
      Host thundurus
        HostName 54.39.157.27
        User ${username}
        Port 22222

      Host knot.0xhckr.dev
        HostName knot.0xhckr.dev
        User git
        Port 2222

      Host 10.0.11.5
        HostName 10.0.11.5
        User ${username}

      Host infernape
        HostName infernape
        User ${username}
        # Forward this machine's 1Password agent into the session so that,
        # when SSH'd in from elsewhere, git auth/signing prompts pop on the
        # machine we're sitting at — not the desktop's unreachable GUI.
        ForwardAgent ~/.1password/agent.sock

      Host *.vm.blacksmith.sh
        StrictHostKeyChecking no
        UserKnownHostsFile /dev/null

      # In a forwarded SSH session, use the forwarded agent ($SSH_AUTH_SOCK)
      # so the 1Password prompt appears on the machine we connected from,
      # instead of this host's local (and headless-to-us) 1Password GUI.
      Match exec "test -n \"$SSH_CONNECTION\""
        IdentityAgent $SSH_AUTH_SOCK

      Host *
        IdentityAgent ~/.1password/agent.sock
    '';
    force = true;
  };
}
