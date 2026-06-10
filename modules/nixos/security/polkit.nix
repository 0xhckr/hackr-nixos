_: {
  # The polkit authentication agent is provided by the noctalia polkit-agent
  # plugin (~/.config/noctalia/plugins/polkit-agent). Running a second agent
  # (polkit-gnome, hyprpolkitagent, ...) alongside it causes conflicts, so no
  # standalone agent service is configured here.
  security.polkit.enable = true;
}
