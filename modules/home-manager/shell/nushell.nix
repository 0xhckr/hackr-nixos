{pkgs, config, lib, ...}: {
  home.shell.enableNushellIntegration = true;

  programs.nushell = {
    enable = true;
    environmentVariables = config.home.sessionVariables;
    extraConfig = ''
      use std "path add"

      path add "/run/current-system/sw/bin"
      path add "~/bin"
      path add "~/.local/bin"
      path add "~/.nix-profile/bin"
      path add "/run/wrappers/bin"
      path add "/var/lib/flatpak/exports/share"
      path add "/home/hackr/.local/share/flatpak/exports/share"

      source ./direnv.nu


      def cl [] {
        clear
        if $env.TMUX? == null {
          ${pkgs.fastfetch}/bin/fastfetch
        }
      }

      def copy-to-cache [] {
        if ($'/home/hackr/.config/nix/secret.key' | path exists) {
          nix store sign --recursive --key-file ~/.config/nix/secret.key /run/current-system
          nix copy --to 's3://nix-cache?profile=nixbuilder&endpoint=10.0.11.2:9000&scheme=http' /run/current-system
          echo "Copied to cache"
        } else {
          echo "~/.config/nix/secret.key not found"
        }
      }

      def rebuild [] {
        do {
          ${pkgs.nh}/bin/nh os switch ~/nixos
        }
        let res = $env.LAST_EXIT_CODE
        if ((hostname) == "infernape" and ($res == 0)) {
          copy-to-cache
        }
      }

      def nr [
        name: string,
        ...rest: string
      ] {
        if $name == "list" {
          nix flake show --json --all-systems | from json | get apps | get (nix eval --impure --expr 'builtins.currentSystem' --raw) | transpose | get column0
        } else {
          let flake_ref = [".#", $name] | str join ""
          ^nix run $flake_ref ...$rest
        }
      }

      def code [...args: string] {
        if $args == null or $args == [] {
          bash -c $"TERM=xterm-256color nohup ${config.home.zedPackage}/bin/zed >/dev/null 2>&1 &"
        } else {
          bash -c $"TERM=xterm-256color nohup ${config.home.zedPackage}/bin/zed ($args | str join ' ') >/dev/null 2>&1 &"
        }
      }

      # Enable zoxide integration
      source ${
        pkgs.runCommand "zoxide-nushell-config.nu" {} ''
          ${lib.getExe pkgs.zoxide} init nushell >> "$out"
        ''
      }

      def --env --wrapped zc [...args: string] {
        if $args == null or $args == [] {
          cd ~
          code
        } else {
          __zoxide_z ...$args
          code .
        }
      }

      def --env --wrapped zic [...args: string] {
        if $args == null or $args == [] {
          __zoxide_zi
          code .
        } else {
          __zoxide_zi ...$args
          code .
        }
      }

      def point-and-kill [] {
        let appPID = ${pkgs.niri}/bin/niri msg pick-window | grep "PID:" | str replace "PID: " "" | into int
        kill -9 $appPID
      }

      ~/.config/nushell/aacpi.sh

      # check if running as xterm-ghostty
      if $env.TERM == "xterm-ghostty" {
        fastfetch
      }
    '';

    shellAliases = {
      pip = "${pkgs.python3}/bin/python3 -m pip";
      g = "${pkgs.git}/bin/git";
      gc = "${pkgs.git}/bin/git commit -m";
      gp = "${pkgs.git}/bin/git push";
      gl = "${pkgs.git}/bin/git pull";
      gco = "${pkgs.git}/bin/git checkout";
      l = "ls -la";
      b = "${pkgs.bun}/bin/bun";
      c = "code";
    };
  };

  home.file = {
    ".config/nushell/direnv.nu" = {
      source = ../../../cfg/nushell/direnv.nu;
    };
    ".config/nushell/aacpi.sh" = {
      source = ../../../cfg/nushell/aacpi.sh;
    };
  };
}
