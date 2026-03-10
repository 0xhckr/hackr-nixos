{...}: {
  # 1Password SSH Agent Configuration
  home.file.".config/1Password/ssh/agent.toml" = {
    text = ''
      [[ssh-keys]]
      vault = "Private"
      item = "Hackr General"
    '';
    force = true;
  };
}
