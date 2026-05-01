{username, ...}: {
  home.file.".ssh/config" = {
    text = ''
      Host thundurus
        HostName 54.39.157.27
        User ${username}
        Port 22222

      Host tngl.hackrlabs.dev
        HostName tngl.hackrlabs.dev
        User git
        Port 2222

      Host 10.0.11.5
        HostName 10.0.11.5
        User ${username}

      Host *
        IdentityAgent ~/.1password/agent.sock
    '';
    force = true;
  };
}
