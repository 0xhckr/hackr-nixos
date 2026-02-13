{username, ...}: {
  home.file.".ssh/config" = {
    text = ''
      Host 10.0.11.5
        HostName 10.0.11.5
        User ${username}

      Host *
        IdentityAgent ~/.1password/agent.sock
    '';
    force = true;
  };
}
