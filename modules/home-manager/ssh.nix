{
  config,
  lib,
  pkgs,
  ...
}:
let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  home.file = {
    ".ssh/config" = if isLinux then {
      text = ''
        Host 10.0.11.5
          HostName 10.0.11.5
          User hackr
        
        Host *
          IdentityAgent ~/.1password/agent.sock
      '';
      force = true;
    } else {
      text = ''
        Include ~/.orbstack/ssh/config

        Host 10.0.11.5
                HostName 10.0.11.5
                User hackr

        Host *
                IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
                AddKeysToAgent yes
                UseKeychain yes
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

    "work/.gitconfig" = if isLinux then{
      source = ../../ssh/work.gitconfig;
      force = true;
    } else {
      source = ../../ssh/work.macos.gitconfig;
      force = true;
    };
    "dev/.gitconfig" = if isLinux then {
      source = ../../ssh/dev.gitconfig;
      force = true;
    } else {
      source = ../../ssh/dev.macos.gitconfig;
      force = true;
    };
    ".gitconfig" = if isLinux then {
      source = ../../ssh/home.gitconfig;
      force = true;
    } else {
      source = ../../ssh/home.macos.gitconfig;
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