{hostname, lib, username, ...}: {
  imports = [
    ./shell
    ./ssh
    ./terminal
    ./ui
    ./apps
    ./dev
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "24.11";
  nixpkgs.config.allowUnfree = true;

  home.file = {
    ".config/atuin" = {
      force = true;
      source = ../../cfg/atuin;
      recursive = true;
    };
    ".config/btop" = {
      force = true;
      source = ../../cfg/btop;
      recursive = true;
    };
    ".config/commie" = {
      force = true;
      source = ../../cfg/commie;
      recursive = true;
    };
    ".config/direnv" = {
      force = true;
      source = ../../cfg/direnv;
      recursive = true;
    };
    ".config/fastfetch" = {
      force = true;
      source = ../../cfg/fastfetch;
      recursive = true;
    };

    ".config/niri/delayed" = {
      force = true;
      source = ../../cfg/niri/delayed;
    };
    ".config/noctalia/colors-original.json" = {
      force = true;
      source = ../../cfg/noctalia/colors-original.json;
    };
    ".config/noctalia/plugins-original.json" = {
      force = true;
      source = ../../cfg/noctalia/plugins-original.json;
    };
    ".local/share/vicinae/themes" = {
      force = true;
      source = ../../share/vicinae/themes;
      recursive = true;
    };
    ".config/zed/themes" = {
      force = true;
      source = ../../cfg/zed/themes;
      recursive = true;
    };
    ".config/zed/keymap.json" = {
      force = true;
      source = ../../cfg/zed/keymap.json;
    };
    ".face" = {
      force = true;
      source = ../../.face;
    };
  };

  home.activation = {
    linkNiriSettings = lib.hm.dag.entryAfter ["linkGeneration"] ''
      #!/usr/bin/env bash
      mkdir -p ~/.config/niri
      cp -L ~/.config/niri/config-original.kdl ~/.config/niri/config.kdl
    '';

    linkNoctaliaSettings = lib.hm.dag.entryAfter ["linkGeneration"] ''
      #!/usr/bin/env bash
      mkdir -p ~/.config/noctalia
      cp -L ~/.config/noctalia/colors-original.json ~/.config/noctalia/colors.json
      cp -L ~/.config/noctalia/plugins-original.json ~/.config/noctalia/plugins.json
      cp -L ~/.config/noctalia/settings-original.json ~/.config/noctalia/settings.json
    '';
  };

  programs.home-manager.enable = true;
}
