{
  pkgs,
  inputs,
  hostname,
  ...
}: {
  imports = [
    ./ssh.nix
    ./terminal.nix
    ./ui.nix
    ./apps.nix
    ./dev.nix
  ];

  home.username = "hackr";
  home.homeDirectory = "/home/hackr";

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
    ".config/ghostty" = {
      force = true;
      source = ../../cfg/ghostty;
      recursive = true;
    };
    ".config/niri/config.kdl" = {
      force = true;
      text = ''
        ${builtins.readFile ../../cfg/niri/config.kdl}
        ${
          if hostname == "hackrwork" || hostname == "hackrfrmw"
          then ''
            ${builtins.readFile ../../cfg/niri/laptop-outputs.kdl}
          ''
          else ""
        }
      '';
    };
    ".config/niri/delayed" = {
      force = true;
      source = ../../cfg/niri/delayed;
    };
    ".config/niri/background" = {
      force = true;
      source = ../../cfg/niri/background;
    };
    ".config/noctalia" = {
      force = true;
      source = ../../cfg/noctalia;
      recursive = true;
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
  };

  programs.home-manager.enable = true;
}
