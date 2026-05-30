{
  lib,
  username,
  ...
}: {
  imports = [
    ./shell
    ./ssh
    ./terminal
    ./ui
    ./apps
    ./dev
    ./work
  ];

  gtk.gtk4.theme = null;

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";

    file = {
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
      ".local/share/vicinae/scripts" = {
        force = true;
        source = ../../cfg/vicinae/scripts;
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

      # Pi agent config (source-of-truth in cfg/pi/)
      ".pi/agent/themes/rose-pine.json" = {
        force = true;
        source = ../../cfg/pi/themes/rose-pine.json;
      };
      ".pi/agent/themes/hackr.json" = {
        force = true;
        source = ../../cfg/pi/themes/hackr.json;
      };
      ".pi/agent/extensions-original/jj-desc-original.ts" = {
        force = true;
        source = ../../cfg/pi/extensions-original/jj-desc-original.ts;
      };
      ".pi/agent/extensions-original/hackr-ui-original.ts" = {
        force = true;
        source = ../../cfg/pi/extensions-original/hackr-ui-original.ts;
      };
      ".pi/agent/extensions-original/web-fetch-original.ts" = {
        force = true;
        source = ../../cfg/pi/extensions-original/web-fetch-original.ts;
      };
      ".pi/agent/extensions-original/package.json" = {
        force = true;
        source = ../../cfg/pi/extensions-original/package.json;
      };
      ".pi/agent/settings-original.json" = {
        force = true;
        source = ../../cfg/pi/settings-original.json;
      };
    };

    activation = {
      linkNiriSettings = lib.hm.dag.entryAfter ["linkGeneration"] ''
        #!/usr/bin/env bash
        mkdir -p ~/.config/niri
        rm -f ~/.config/niri/config.kdl
        cp -L ~/.config/niri/config-original.kdl ~/.config/niri/config.kdl
      '';

      linkNoctaliaSettings = lib.hm.dag.entryAfter ["linkGeneration"] ''
        #!/usr/bin/env bash
        mkdir -p ~/.config/noctalia
        rm -f ~/.config/noctalia/colors.json ~/.config/noctalia/plugins.json ~/.config/noctalia/settings.json
        cp -L ~/.config/noctalia/colors-original.json ~/.config/noctalia/colors.json
        cp -L ~/.config/noctalia/plugins-original.json ~/.config/noctalia/plugins.json
        cp -L ~/.config/noctalia/settings-original.json ~/.config/noctalia/settings.json
      '';

      linkPiSettings = lib.hm.dag.entryAfter ["linkGeneration"] ''
        #!/usr/bin/env bash
        mkdir -p ~/.pi/agent
        mkdir -p ~/.pi/agent/extensions
        mkdir -p ~/.bun/install/global
        rm -f ~/.pi/agent/settings.json
        rm -f ~/.pi/agent/extensions/jj-desc.ts ~/.pi/agent/extensions/hackr-ui.ts ~/.pi/agent/extensions/web-fetch.ts
        rm -f ~/.bun/install/global/package.json
        rm -f ~/.pi/agent/extensions/package.json
        cp -L ~/.pi/agent/settings-original.json ~/.pi/agent/settings.json
        cp -L ~/.pi/agent/extensions-original/jj-desc-original.ts ~/.pi/agent/extensions/jj-desc.ts
        cp -L ~/.pi/agent/extensions-original/hackr-ui-original.ts ~/.pi/agent/extensions/hackr-ui.ts
        cp -L ~/.pi/agent/extensions-original/web-fetch-original.ts ~/.pi/agent/extensions/web-fetch.ts
        # Install npm dependencies for extensions
        cp -L ~/.pi/agent/extensions-original/package.json ~/.pi/agent/extensions/package.json
        cd ~/.pi/agent/extensions && bun install --production || echo "WARN: bun install failed for Pi extensions (cwd: ~/.pi/agent/extensions)" >&2
        # Ensure bun global install dir has a valid package.json
        if [ ! -f ~/.bun/install/global/package.json ]; then
          echo '{"name":"global"}' > ~/.bun/install/global/package.json
        fi
      '';
    };
  };
}
