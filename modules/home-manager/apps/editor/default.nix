{
  inputs,
  pkgs,
  system,
  lib,
  ...
}: let
  extensionDependencies = with pkgs; [
    openssl
    zlib
  ];

  zedPackage = pkgs.buildFHSEnv {
    name = "zed";
    targetPkgs = pkgs:
      [
        inputs.zed.packages."${system}".default
      ]
      ++ extensionDependencies;
    runScript = "zed";
    extraInstallCommands = ''
      mkdir -p $out/share/applications
      cp ${inputs.zed.packages."${system}".default}/share/applications/*.desktop $out/share/applications/
    '';
  };
in {
  imports = [
    ./language-servers.nix
  ];

  options.home.zedPackage = lib.mkOption {
    type = lib.types.package;
    description = "The zed editor package built from flakes with FHS environment";
  };

  config = {
    # We add extension specific dependencies so they show up when
    # zed is launched via the terminal and also when it's launched
    # using an app launcher
    home.packages = [] ++ extensionDependencies;

    programs.zed-editor = {
      enable = true;
      package = zedPackage;
      extensions = [
        "catppuccin-icons"
        "discord-presence"
        "ghostty"
        "html"
        "java"
        "nix"
        "prisma"
        "sql"
        "toml"
      ];
    };

    # export zedPackage for use in other modules
    home.zedPackage = zedPackage;

    home.activation = {
      linkZedSettings = lib.hm.dag.entryAfter ["linkGeneration"] ''
        #!/usr/bin/env bash
        mkdir -p ~/.config/zed
        cp -L ~/.config/zed/settings-original.json ~/.config/zed/settings.json
      '';
    };
    home.file.".config/zed/settings-original.json" = {
      source = ./settings.json;
      force = true;
    };
  };
}
