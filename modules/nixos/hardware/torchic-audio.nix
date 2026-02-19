{...}: {
  # Workaround for AMD audio issues on some systems
  # Note: make sure "Analog Studio Duplex" is selected in the Configuration Profile
  # for Family 17h/19h/1ah HD Audio Controller and that the gain is at 50%
  services.pipewire.wireplumber.extraConfig.no-ucm = {
    "monitor.alsa.properties" = {
      "alsa.use-ucm" = false;
    };
  };
}
