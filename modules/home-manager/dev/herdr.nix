_: {
  # herdr resolves pane shells in this order: [terminal].default_shell, then
  # $SHELL of the herdr *server* process, then /bin/sh. The server is
  # long-lived and keeps whatever SHELL it was first spawned with. Use the
  # stable system profile path so garbage collection cannot invalidate it.
  home.file.".config/herdr/config-original.toml" = {
    force = true;
    text = ''
      onboarding = false

      [terminal]
      default_shell = "/run/current-system/sw/bin/nu"

      [ui.toast]
      delivery = "system"

      [ui]
      show_agent_labels_on_pane_borders = true
      agent_panel_sort = "spaces"

      [experimental]
      switch_ascii_input_source_in_prefix = false

      [theme]
      name = "rose-pine"
      auto_switch = false
    '';
  };
}
