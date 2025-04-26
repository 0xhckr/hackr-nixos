{
  config,
  lib,
  ...
}:
{
  home.file = {
    ".ssh/config" = {
      text = ''
        Host 10.0.11.5
          HostName 10.0.11.1
          User hackr
        
        Host *
          IdentityAgent ~/.1password/agent.sock
      '';
      force = true;
    };
    ".config/1Password/ssh/agent.toml" = {
      text = ''
        [[ssh-keys]]
        vault = "Private"
        item = "Hackr General"
        
        [[ssh-keys]]
        vault = "KnowHistory"
        item = "KnowHistory"
      '';
      force = true;
    };
    "work/.gitconfig" = {
      source = ../../ssh/work.gitconfig;
      force = true;
    };
    "dev/.gitconfig" = {
      source = ../../ssh/dev.gitconfig;
      force = true;
    };
    ".gitconfig" = {
      source = ../../ssh/home.gitconfig;
      force = true;
    };
    ".ssh/id_rsa_work.pub" = {
      source = ../../ssh/id_rsa_work.pub;
      force = true;
    };
    ".ssh/id_rsa_personal.pub" = {
      source = ../../ssh/id_rsa_personal.pub;
      force = true;
    };
  };
}