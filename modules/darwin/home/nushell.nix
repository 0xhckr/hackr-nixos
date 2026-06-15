# Nushell config. Nushell itself comes from Homebrew (see ../homebrew.nix);
# here we only manage its config files. On macOS nushell reads its config from
# ~/Library/Application Support/nushell, not ~/.config/nushell.
{username, ...}: let
  configDir = "Library/Application Support/nushell";
in {
  home.file = {
    # Shared, cross-platform direnv hook (also used by the NixOS config).
    "${configDir}/direnv.nu".source = ../../../cfg/nushell/direnv.nu;

    "${configDir}/env.nu".text = ''
      # Make bare `nh darwin switch` target this flake.
      $env.NH_FLAKE = "/Users/${username}/nixos"
    '';

    "${configDir}/config.nu".text = ''
      use std "path add"

      path add "/opt/homebrew/bin"
      path add "/run/current-system/sw/bin"
      path add "/etc/profiles/per-user/${username}/bin"
      path add "~/.nix-profile/bin"
      path add "~/.local/bin"
      path add "~/bin"

      # direnv hook
      source ./direnv.nu

      # starship prompt (init rendered at build time; see starship.nix)
      source ./starship-init.nu

      # Rebuild helpers, mirroring the NixOS aliases. `nh darwin` only has
      # switch/build (macOS has no bootloader generations), so re-test maps to
      # a non-activating build and re-boot maps to switch.
      def re-switch [] { nh darwin switch ~/nixos }
      def re-test [] { nh darwin build ~/nixos }
      def re-boot [] { nh darwin switch ~/nixos }

      # fastfetch (Homebrew) + pokeget-rs (nix) side by side, sprite picked
      # from the hostname — so `metagross` renders the Metagross sprite.
      def pokefetch [] {
        let FETCHER_CMD = "fastfetch --logo none"
        let EXTRA_PADDING_H = 2
        let EXTRA_PADDING_W = 2
        let WIDTH = 38

        # Strip any domain suffix (e.g. metagross.local -> metagross).
        let pokemon_name = (hostname | split row "." | first)

        let sprite = (pokeget $pokemon_name --hide-name | complete | get stdout)

        let fetcher_height = (bash -c $FETCHER_CMD | lines | length)
        let sprite_height = ($sprite | lines | length)

        let pad_top = (($fetcher_height - $sprite_height) / 2 + $EXTRA_PADDING_H)
        let pad_top = (if $pad_top < 0 { 0 } else { $pad_top })

        let sprite_width = ($sprite | lines | each { |line|
          $line | ansi strip | split chars | length
        } | math max)

        let pad_horizontal = (($WIDTH - $sprite_width) / 2 + $EXTRA_PADDING_W)
        let pad_horizontal = (if $pad_horizontal < 0 { 0 } else { $pad_horizontal })
        let pad_horizontal = ($pad_horizontal | math floor)
        let pad_top = ($pad_top | math floor)

        $sprite | fastfetch --file-raw - --logo-padding $pad_horizontal --logo-padding-top $pad_top
      }

      def cl [] {
        clear
        if $env.TMUX? == null {
          pokefetch
        }
      }

      $env.config.show_banner = false

      # Greet on interactive ghostty sessions, like the NixOS config.
      if $env.TERM == "xterm-ghostty" {
        pokefetch
      }
    '';
  };
}
