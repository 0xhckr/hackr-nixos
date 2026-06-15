# SSH client config + 1Password SSH agent.
{
  username,
  x86_systems,
  aarch64_systems,
  ...
}: let
  # macOS 1Password SSH agent socket (differs from the Linux ~/.1password path).
  agentSock = "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
in {
  home.file = {
    ".ssh/config" = {
      force = true;
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

        # Forward this Mac's 1Password agent into these sessions so that git
        # auth/signing prompts pop here, on the machine we're sitting at.
        ${builtins.concatStringsSep "\n\n" (map (host: ''
            Host ${host}
              HostName ${host}
              User ${username}
              ForwardAgent ${agentSock}
          '')
          (x86_systems ++ aarch64_systems))}

        Host *.vm.blacksmith.sh
          StrictHostKeyChecking no
          UserKnownHostsFile /dev/null

        # In a forwarded SSH session, use the forwarded agent ($SSH_AUTH_SOCK)
        # so the 1Password prompt appears on the machine we connected from.
        # Force POSIX sh for the test (the login shell may be nushell).
        Match exec "sh -c 'test -n \"$SSH_CONNECTION\"'"
          IdentityAgent $SSH_AUTH_SOCK

        Host *
          IdentityAgent ${agentSock}
      '';
    };

    ".ssh/id_rsa.pub" = {
      source = ../../../ssh/id_rsa.pub;
      force = true;
    };

    # Which key the 1Password SSH agent offers.
    ".config/1Password/ssh/agent.toml" = {
      force = true;
      text = ''
        [[ssh-keys]]
        vault = "Private"
        item = "Hackr General"
      '';
    };
  };
}
