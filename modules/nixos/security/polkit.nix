_: {
  # The polkit authentication agent is built into noctalia v5 itself
  # ([shell] polkit_agent = true in modules/home-manager/ui/noctalia.nix).
  # Running a second agent (polkit-gnome, hyprpolkitagent, ...) alongside it
  # causes conflicts, so no standalone agent service is configured here.
  security.polkit.enable = true;
}
