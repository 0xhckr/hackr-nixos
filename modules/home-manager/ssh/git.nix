{pkgs, ...}: {
  home.file = {
    ".gitconfig" = {
      source = ../../../ssh/home.gitconfig;
      force = true;
    };
    ".config/jj/config.toml" = {
      source = ../../../ssh/home.jj-config.toml;
      force = true;
    };

    # SSH commit-signing helper used by both git and jj.
    # In a forwarded SSH session sign via ssh-keygen against the forwarded
    # 1Password agent (prompt shows on the machine we connected from); locally,
    # use op-ssh-sign against this host's 1Password app.
    ".ssh/git-ssh-sign" = {
      text = ''
        #!/usr/bin/env bash
        if [ -n "$SSH_CONNECTION" ]; then
          exec ${pkgs.openssh}/bin/ssh-keygen "$@"
        else
          exec /run/current-system/sw/bin/op-ssh-sign "$@"
        fi
      '';
      executable = true;
      force = true;
    };
  };
}
