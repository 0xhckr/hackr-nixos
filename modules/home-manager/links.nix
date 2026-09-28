{
  lib,
  inputs,
  username,
  pkgs,
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
      ".config/opencode/AGENTS.md" = {
        force = true;
        source = ../../cfg/agents/AGENTS.md;
      };
      ".claude/CLAUDE.md" = {
        force = true;
        source = ../../cfg/agents/AGENTS.md;
      };
      ".codex/AGENTS.md" = {
        force = true;
        source = ../../cfg/agents/AGENTS.md;
      };
      ".local/share/obsidian-themes/Pierre Dark" = {
        force = true;
        source = "${../../cfg/obsidian/themes}/Pierre Dark";
        recursive = true;
      };

      ".config/niri/delayed" = {
        force = true;
        source = ../../cfg/niri/delayed;
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

    };

    activation = {
      linkHerdrConfig = lib.hm.dag.entryAfter ["linkGeneration"] ''
        #!/usr/bin/env bash
        mkdir -p ~/.config/herdr
        rm -f ~/.config/herdr/config.toml
        cp -L ~/.config/herdr/config-original.toml ~/.config/herdr/config.toml
      '';

      linkNiriSettings = lib.hm.dag.entryAfter ["linkGeneration"] ''
        #!/usr/bin/env bash
        mkdir -p ~/.config/niri
        rm -f ~/.config/niri/config.kdl
        cp -L ~/.config/niri/config-original.kdl ~/.config/niri/config.kdl
      '';

      linkObsidianThemes = lib.hm.dag.entryAfter ["linkGeneration"] ''
        #!/usr/bin/env bash
        for vault_themes in ~/.obs/.obsidian/themes /home/*/*/.obsidian/themes; do
          [ -d "$(dirname "$(dirname "$vault_themes")")" ] || continue
          mkdir -p "$vault_themes/Pierre Dark"
          rm -f "$vault_themes/Pierre Dark/manifest.json" "$vault_themes/Pierre Dark/theme.css"
          cp -L ~/.local/share/obsidian-themes/Pierre\ Dark/manifest.json "$vault_themes/Pierre Dark/manifest.json"
          cp -L ~/.local/share/obsidian-themes/Pierre\ Dark/theme.css "$vault_themes/Pierre Dark/theme.css"
          chmod 644 "$vault_themes/Pierre Dark/manifest.json" "$vault_themes/Pierre Dark/theme.css"
        done
      '';

    };
  };
}
