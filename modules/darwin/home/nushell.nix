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

      # Rebuild helpers — the macOS analogue of NixOS `re-switch`/`re-test`.
      def re-switch [] { nh darwin switch ~/nixos }
      def re-build [] { nh darwin build ~/nixos }

      $env.config.show_banner = false
    '';
  };
}
