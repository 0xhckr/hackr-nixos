# paneru — a niri-style scrollable-tiling window manager for macOS, built from
# its own flake (github:karinushka/paneru) rather than Homebrew.
#
# The upstream home-manager module (services.paneru) installs the package,
# renders ~/.config/paneru/paneru.toml from `settings`, and registers a launchd
# LaunchAgent (com.github.karinushka.paneru) that starts paneru at login and
# restarts it on crash. Logs go to /tmp/paneru.log and /tmp/paneru.err.log.
#
# First launch: macOS will prompt for Accessibility access (paneru needs it to
# move windows). Grant it under System Settings → Privacy & Security →
# Accessibility, then `launchctl kickstart -k gui/$(id -u)/com.github.karinushka.paneru`
# (or just log out/in) so it picks up the permission.
{inputs, ...}: {
  imports = [inputs.paneru.homeModules.paneru];

  services.paneru = {
    enable = true;

    # Config lives at ~/.config/paneru/paneru.toml, generated from this attrset.
    # Left at upstream defaults for now — see paneru's config guide and add keys
    # here (gaps, mod key, layout, per-app rules) to tune the scrollable layout.
    # settings = { };
  };
}
