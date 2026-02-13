{lib, ...}: {
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      format = ''
        ($nix_shell$container$git_metrics)$cmd_duration$hostname$localip$shlvl$shell$env_var$sudo$character
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
        format = "[ ](fg:overlayd)[ $path ]($style)[ ](fg:overlayd) ";
        style = "bg:overlayd fg:pine";
        truncation_length = 5;
        truncation_symbol = " ";
        truncate_to_repo = false;
        substitutions = {
          Documents = " ";
          Downloads = " ";
          Music = " ";
          Pictures = " ";
          nixos = " ";
        };
      };
      fill = {
        style = "fg:overlay";
        symbol = " ";
      };
      git_branch = {
        format = "[ ](fg:overlaydd)[ $symbol $branch ]($style)[ ](fg:overlaydd) ";
        style = "bg:overlaydd fg:foam";
        symbol = " ";
      };
      git_status = {
        disabled = false;
        style = "bg:overlaydd fg:love";
        format = "[ ](fg:overlaydd)([$all_status$ahead_behind]($style))[ ](fg:overlaydd) ";
        up_to_date = "[ ✓ ](bg:overlaydd fg:iris)";
        untracked = "[?\($count\)](bg:overlaydd fg:gold)";
        stashed = "[ ]($count)(bg:overlaydd fg:gold)";
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
        format = "[ ](fg:overlay)[ $time ]($style)[ ](fg:overlay)";
        style = "bg:overlay fg:rose";
        time_format = "%I:%M%P";
        use_12hr = true;
      };
      username = {
        disabled = false;
        format = "[ ](fg:overlay)[  $user ]($style)[ ](fg:overlay) ";
        show_always = true;
        style_root = "bg:overlay fg:iris";
        style_user = "bg:overlay fg:iris";
      };
      hostname = {
        disabled = false;
        format = "[ ](fg:overlayd)[  $hostname ]($style)[ ](fg:overlayd) ";
        style = "bg:overlayd fg:iris";
        ssh_only = false;
      };
      c = {
        style = "bg:overlay fg:pine";
        format = "[ ](fg:overlay)[$symbol$version]($style)[ ](fg:overlay) ";
        disabled = false;
        symbol = "  ";
      };
      elixir = {
        style = "bg:overlay fg:pine";
        format = "[ ](fg:overlay)[$symbol$version]($style)[ ](fg:overlay) ";
        disabled = false;
        symbol = "  ";
      };
      elm = {
        style = "bg:overlay fg:pine";
        format = "[ ](fg:overlay)[$symbol$version]($style)[ ](fg:overlay) ";
        disabled = false;
        symbol = "  ";
      };
      golang = {
        style = "bg:overlay fg:pine";
        format = "[ ](fg:overlay)[$symbol$version]($style)[ ](fg:overlay) ";
        disabled = false;
        symbol = "  ";
      };
      haskell = {
        style = "bg:overlay fg:pine";
        format = "[ ](fg:overlay)[$symbol$version]($style)[ ](fg:overlay) ";
        disabled = false;
        symbol = "  ";
      };
      java = {
        style = "bg:overlay fg:pine";
        format = "[ ](fg:overlay)[$symbol$version]($style)[ ](fg:overlay) ";
        disabled = false;
        symbol = "  ";
      };
      julia = {
        style = "bg:overlay fg:pine";
        format = "[ ](fg:overlay)[$symbol$version]($style)[ ](fg:overlay) ";
        disabled = false;
        symbol = "  ";
      };
      nodejs = {
        style = "bg:overlay fg:pine";
        format = "[ ](fg:overlay)[$symbol$version]($style)[ ](fg:overlay) ";
        disabled = false;
        symbol = "  ";
      };
      nim = {
        style = "bg:overlay fg:pine";
        format = "[ ](fg:overlay)[$symbol$version]($style)[ ](fg:overlay) ";
        disabled = false;
        symbol = "  ";
      };
      rust = {
        style = "bg:overlay fg:pine";
        format = "[ ](fg:overlay)[$symbol$version]($style)[ ](fg:overlay) ";
        disabled = false;
        symbol = "  ";
      };
      scala = {
        style = "bg:overlay fg:pine";
        format = "[ ](fg:overlay)[$symbol$version]($style)[ ](fg:overlay) ";
        disabled = false;
        symbol = "  ";
      };
      python = {
        style = "bg:overlay fg:pine";
        format = "[ ](fg:overlay)[$symbol$version]($style)[ ](fg:overlay) ";
        disabled = false;
        symbol = "  ";
      };
    };
  };
}
