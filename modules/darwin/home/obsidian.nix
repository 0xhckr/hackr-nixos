# Obsidian theme: Pierre Dark. Obsidian itself comes from Homebrew (see
# ../homebrew.nix); here we only manage the theme files.
#
# Obsidian on macOS looks for vault themes in <vault>/.obsidian/themes/, same
# as Linux. The home.file entry stages the theme in a stable location; the
# activation script copies real files (not symlinks) into each vault —
# Electron/Obsidian doesn't follow nix store symlinks for theme files.
{lib, ...}: {
  home.file.".local/share/obsidian-themes/Pierre Dark" = {
    force = true;
    source = "${../../../cfg/obsidian/themes}/Pierre Dark";
    recursive = true;
  };

  home.activation.linkObsidianThemes = lib.hm.dag.entryAfter ["linkGeneration"] ''
    #!/usr/bin/env bash
    for vault_themes in ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/.obsidian/themes \
                       ~/*/.obsidian/themes ~/*/*/.obsidian/themes; do
      [ -d "$(dirname "$(dirname "$vault_themes")")" ] || continue
      mkdir -p "$vault_themes/Pierre Dark"
      rm -f "$vault_themes/Pierre Dark/manifest.json" "$vault_themes/Pierre Dark/theme.css"
      cp -L ~/.local/share/obsidian-themes/Pierre\ Dark/manifest.json "$vault_themes/Pierre Dark/manifest.json"
      cp -L ~/.local/share/obsidian-themes/Pierre\ Dark/theme.css "$vault_themes/Pierre Dark/theme.css"
      chmod 644 "$vault_themes/Pierre Dark/manifest.json" "$vault_themes/Pierre Dark/theme.css"
    done
  '';
}
