{
  pkgs,
  config,
  lib,
  ...
}: {
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
        if ((hostname) == "hackrpc" and ($res == 0)) {
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
          bash -c $"nohup ${pkgs.vscode-fhs}/bin/code >/dev/null 2>&1 &"
        } else {
          bash -c $"nohup ${pkgs.vscode-fhs}/bin/code ($args | str join ' ') >/dev/null 2>&1 &"
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

      fastfetch
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

  programs.atuin = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    # we enable zoxide in our own config file but we need to do so earlier so that our helper zc and zic functions work.
    enableNushellIntegration = false;
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      format = ''
        ($nix_shell$container$git_metrics)$cmd_duration$hostname$localip$shlvl$shell$env_var$jobs$sudo$username$character
      '';
      right_format = ''
        $singularity$kubernetes$directory$vcsh$fossil_branch$git_branch$git_commit$git_state$git_status$hg_branch$pijul_channel$docker_context$package$c$cpp$cmake$cobol$daml$dart$deno$dotnet$elixir$elm$erlang$fennel$fortran$golang$guix_shell$haskell$haxe$helm$java$julia$kotlin$gradle$lua$nim$nodejs$ocaml$opa$perl$php$pulumi$purescript$python$raku$rlang$red$ruby$rust$scala$solidity$swift$terraform$vlang$vagrant$xmake$zig$buf$conda$pixi$meson$spack$memory_usage$aws$gcloud$openstack$azure$crystal$custom$status$os$battery$time
      '';
      palette = lib.mkForce "poimandres";
      palettes.oscura-midnight = {
        overlay = "#232323";
        overlayd = "#161616";
        overlaydd = "#0b0b0f";
        love = "#d84f68";
        gold = "#f9b98c";
        rose = "#e6e7a3";
        pine = "#4ebe96";
        foam = "#54c0a3";
        iris = "#e6e7a3";
      };
      palettes.poimandres = {
        overlay = "#252b37";
        overlayd = "#171922";
        overlaydd = "#1b1e28";
        love = "#d0679d";
        gold = "#add7ff";
        rose = "#5de4c7";
        pine = "#4ebe96";
        foam = "#54c0a3";
        iris = "#ffffff";
      };
      directory = {
        format = "[](fg:overlayd)[ $path ]($style)[](fg:overlayd) ";
        style = "bg:overlayd fg:pine";
        truncation_length = 5;
        truncation_symbol = "";
        truncate_to_repo = false;
        substitutions = {
          Documents = "󰈙";
          Downloads = " ";
          Music = " ";
          Pictures = " ";
        };
      };
      fill = {
        style = "fg:overlay";
        symbol = " ";
      };
      git_branch = {
        format = "[](fg:overlaydd)[ $symbol $branch ]($style)[](fg:overlaydd) ";
        style = "bg:overlaydd fg:foam";
        symbol = "";
      };
      git_status = {
        disabled = false;
        style = "bg:overlaydd fg:love";
        format = "[](fg:overlaydd)([$all_status$ahead_behind]($style))[](fg:overlaydd) ";
        up_to_date = "[ ✓ ](bg:overlaydd fg:iris)";
        untracked = "[?\($count\)](bg:overlaydd fg:gold)";
        stashed = "[$](bg:overlaydd fg:iris)";
        modified = "[!\($count\)](bg:overlaydd fg:gold)";
        renamed = "[»\($count\)](bg:overlaydd fg:iris)";
        deleted = "[✘\($count\)](style)";
        staged = "[++\($count\)](bg:overlaydd fg:gold)";
        ahead = "[⇡\($\{count\}\)](bg:overlaydd fg:foam)";
        diverged = "⇕[\[](bg:overlaydd fg:iris)[⇡\($\{ahead_count\}\)](bg:overlaydd fg:foam)[⇣\($\{behind_count\}\)](bg:overlaydd fg:rose)[\]](bg:overlaydd fg:iris)";
        behind = "[⇣\($\{count\}\)](bg:overlaydd fg:rose)";
      };
      time = {
        disabled = false;
        format = "[](fg:overlay)[ $time 󰴈 ]($style)[](fg:overlay)";
        style = "bg:overlay fg:rose";
        time_format = "%I:%M%P";
        use_12hr = true;
      };
      username = {
        disabled = false;
        format = "[](fg:overlay)[ 󰧱 $user ]($style)[](fg:overlay) ";
        show_always = true;
        style_root = "bg:overlay fg:iris";
        style_user = "bg:overlay fg:iris";
      };
      hostname = {
        disabled = false;
        format = "[](fg:overlayd)[   $hostname ]($style)[](fg:overlayd) ";
        style = "bg:overlayd fg:iris";
        ssh_only = false;
      };
      c = {
        style = "bg:overlay fg:pine";
        format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) ";
        disabled = false;
        symbol = " ";
      };
      elixir = {
        style = "bg:overlay fg:pine";
        format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) ";
        disabled = false;
        symbol = " ";
      };
      elm = {
        style = "bg:overlay fg:pine";
        format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) ";
        disabled = false;
        symbol = " ";
      };
      golang = {
        style = "bg:overlay fg:pine";
        format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) ";
        disabled = false;
        symbol = " ";
      };
      haskell = {
        style = "bg:overlay fg:pine";
        format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) ";
        disabled = false;
        symbol = " ";
      };
      java = {
        style = "bg:overlay fg:pine";
        format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) ";
        disabled = false;
        symbol = " ";
      };
      julia = {
        style = "bg:overlay fg:pine";
        format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) ";
        disabled = false;
        symbol = " ";
      };
      nodejs = {
        style = "bg:overlay fg:pine";
        format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) ";
        disabled = false;
        symbol = " ";
      };
      nim = {
        style = "bg:overlay fg:pine";
        format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) ";
        disabled = false;
        symbol = " ";
      };
      rust = {
        style = "bg:overlay fg:pine";
        format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) ";
        disabled = false;
        symbol = " ";
      };
      scala = {
        style = "bg:overlay fg:pine";
        format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) ";
        disabled = false;
        symbol = " ";
      };
      conda = {
        style = "bg:overlay fg:pine";
        format = "[](fg:overlay)[$symbol$environment]($style)[](fg:overlay) ";
        disabled = false;
        symbol = " ";
      };
      python = {
        style = "bg:overlay fg:pine";
        format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) ";
        disabled = false;
        symbol = " ";
      };
    };
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  home.file = {
    ".config/nushell/direnv.nu" = {
      source = ../../cfg/nushell/direnv.nu;
    };
    ".config/nushell/aacpi.sh" = {
      source = ../../cfg/nushell/aacpi.sh;
    };
  };
}
