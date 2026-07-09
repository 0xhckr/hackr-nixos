# Ghostty config, ported from the NixOS config (modules/home-manager/terminal/
# ghostty.nix). ghostty itself comes from Homebrew (see ../homebrew.nix); here
# we only manage its config. On macOS ghostty reads ~/.config/ghostty/config
# (XDG), same as Linux, so the layout matches.
#
# Differences from the NixOS version:
#   - Keybinds translated to macOS conventions (cmd instead of ctrl/super), so
#     ctrl+w/k/n/f stay free for shell line-editing.
#   - working-directory points at /Users instead of /home.
#   - Dropped the X11-only keys (class, x11-instance-name), which macOS ignores.
# The font (DepartureMono Nerd Font) is installed via the Homebrew font cask.
{username, ...}: {
  home.file.".config/ghostty/themes/pierre-dark" = {
    force = true;
    source = ../../../cfg/ghostty/themes/pierre-dark;
  };

  home.file.".config/ghostty/themes/pierre-light" = {
    force = true;
    source = ../../../cfg/ghostty/themes/pierre-light;
  };

  home.file.".config/ghostty/config" = {
    force = true;
    text = ''
      font-family = "DepartureMono Nerd Font"
      font-style = default
      font-style-bold = default
      font-style-italic = default
      font-style-bold-italic = default
      font-synthetic-style = bold,italic,bold-italic
      font-size = 14
      font-thicken = false
      grapheme-width-method = unicode
      # Follows the desktop color-scheme preference; window-theme = auto below
      # makes ghostty honor the macOS light/dark setting live.
      theme = dark:pierre-dark,light:pierre-light
      cursor-style = bar
      mouse-hide-while-typing = true

      mouse-shift-capture = false
      # Translucent background + macOS blur. Opacity is dropped a touch so the
      # blur actually reads through; background-blur is the macOS blur radius.
      background-opacity = 0.82
      background-blur = 40
      unfocused-split-opacity = 0.55
      scrollback-limit = 10000000

      link-url = true
      fullscreen = false
      title =
      working-directory = "/Users/${username}"

      # Keybinds use macOS-native cmd (the NixOS config used ctrl/super).
      keybind = cmd+alt+i=inspector:toggle
      keybind = cmd+w=close_surface
      keybind = cmd+enter=toggle_fullscreen
      keybind = cmd+t=new_tab
      keybind = cmd+shift+right_bracket=next_tab
      keybind = cmd+shift+left_bracket=previous_tab

      keybind = cmd+equal=increase_font_size:1
      keybind = cmd+minus=decrease_font_size:1

      keybind = cmd+comma=open_config
      keybind = cmd+shift+r=reload_config

      keybind = cmd+a=select_all
      keybind = cmd+c=copy_to_clipboard
      keybind = cmd+v=paste_from_clipboard

      keybind = cmd+n=new_window
      keybind = cmd+zero=reset_font_size
      keybind = cmd+k=clear_screen

      keybind = cmd+d=new_split:right
      keybind = cmd+shift+d=new_split:down

      keybind = cmd+alt+right=goto_split:right
      keybind = cmd+alt+down=goto_split:bottom
      keybind = cmd+alt+left=goto_split:left
      keybind = cmd+alt+up=goto_split:top
      keybind = cmd+left_bracket=goto_split:previous
      keybind = cmd+right_bracket=goto_split:next

      keybind = cmd+f=start_search

      keybind = cmd+physical:one=goto_tab:1
      keybind = cmd+physical:two=goto_tab:2
      keybind = cmd+physical:three=goto_tab:3
      keybind = cmd+physical:four=goto_tab:4
      keybind = cmd+physical:five=goto_tab:5
      keybind = cmd+physical:six=goto_tab:6
      keybind = cmd+physical:seven=goto_tab:7
      keybind = cmd+physical:eight=goto_tab:8
      keybind = cmd+physical:nine=goto_tab:9
      keybind = cmd+physical:zero=last_tab

      # Quick terminal. global: requires Accessibility permission on macOS, and
      # cmd+` is macOS's "cycle app windows" — rebind if that conflicts.
      keybind = global:cmd+grave_accent=toggle_quick_terminal

      window-padding-x = 16
      window-padding-y = 8
      window-padding-balance = false
      window-padding-color = extend
      # keep the following enabled unless you want to test out what a kernel panic looks like
      window-vsync = true
      window-inherit-font-size = true
      # window-title-font-family = "0xProto Nerd Font Mono"
      window-theme = auto
      window-colorspace = srgb
      # Native macOS tabs that live in the titlebar, with a translucent titlebar
      # so the blur carries all the way up. Hide the doc proxy icon for a
      # cleaner look.
      macos-titlebar-style = tabs
      macos-titlebar-proxy-icon = hidden
      macos-window-shadow = true
      window-height = 0
      window-width = 0
      window-save-state = default
      window-step-resize = false
      window-new-tab-position = current

      resize-overlay = after-first
      resize-overlay-position = center
      resize-overlay-duration = 750ms

      focus-follows-mouse = true

      clipboard-read = allow
      clipboard-write = allow
      clipboard-trim-trailing-spaces = true
      clipboard-paste-protection = true
      clipboard-paste-bracketed-safe = true
      image-storage-limit = 320000000
      copy-on-select = true
      click-repeat-interval = 0

      confirm-close-surface = false
      quit-after-last-window-closed = false
      initial-window = true
      shell-integration = detect
      shell-integration-features = cursor,title,ssh-terminfo,sudo
      osc-color-report-format = 16-bit
      vt-kam-allowed = false
      desktop-notifications = true
      bold-is-bright = true
      # Keep native window decorations so macos-titlebar-style = tabs has a
      # titlebar to render the tab bar into.
      window-decoration = auto
      window-inherit-working-directory = true

      # This will be used to set the `TERM` environment variable.
      # HACK: We set this with an `xterm` prefix because vim uses that to enable key
      # protocols (specifically this will enable `modifyOtherKeys`), among other
      # features. An option exists in vim to modify this: `:set
      # keyprotocol=ghostty:kitty`, however a bug in the implementation prevents it
      # from working properly. https://github.com/vim/vim/pull/13211 fixes this.
      term = xterm-ghostty
    '';
  };
}
