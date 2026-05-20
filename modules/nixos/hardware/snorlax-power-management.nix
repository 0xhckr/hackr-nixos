{...}: {
  services.logind.lidSwitchExternalPower = "ignore";

  # systemd.sleep.settings.Sleep = ''
  #   AllowSuspend=no
  #   AllowHibernation=no
  #   AllowHybridSleep=no
  #   AllowSuspendThenHibernate=no
  # '';
}
