{
  config,
  lib,
  pkgs-stable,
  ...
}: let
  hasFingerPrintSensor = config.networking.hostName == "torchic" || config.networking.hostName == "flareon";
in {
  # Fingerprint authentication (torchic-specific)
  services.fprintd = {
    enable = hasFingerPrintSensor;
    tod.driver = pkgs-stable.libfprint-2-tod1-vfs0090;
  };

  environment.systemPackages = with pkgs-stable; [
    fprintd
  ];

  # The sensor can come back from s2idle in a state the daemon no longer
  # talks to; restart fprintd on resume if it was running across suspend.
  powerManagement.resumeCommands = lib.mkIf hasFingerPrintSensor ''
    ${config.systemd.package}/bin/systemctl try-restart fprintd.service
  '';

  # Only enable fingerprint auth when lid is open
  security.pam.services = let
    fprintd-only-if-lid-open = {
      enable = hasFingerPrintSensor;
      order = 0;
      control = "[success=ok default=1]";
      modulePath = "${config.security.pam.package}/lib/security/pam_exec.so";
      args = [
        "quiet"
        "quiet_log"
        "${pkgs-stable.writeShellScript "is-lid-open" ''
          set -euo pipefail
          lidstate="$(${config.systemd.package}/bin/busctl get-property org.freedesktop.login1 /org/freedesktop/login1 org.freedesktop.login1.Manager LidClosed 2>/dev/null)"

          if [ "''${lidstate}" = "b false" ]; then
            exit 0
          fi

          exit 1
        ''}"
      ];
    };
  in {
    "1password" = {
      fprintAuth = hasFingerPrintSensor;
      rules.auth = {
        inherit fprintd-only-if-lid-open;
        # Cap the fingerprint wait so a wedged sensor can never block the
        # fall-through to password auth.
        fprintd.settings.timeout = 10;
      };
    };
    "polkit-1" = {
      fprintAuth = hasFingerPrintSensor;
      rules.auth = {
        inherit fprintd-only-if-lid-open;
        # Cap the fingerprint wait so a wedged sensor can never block the
        # fall-through to password auth.
        fprintd.settings.timeout = 10;
      };
    };
    "sudo" = {
      fprintAuth = hasFingerPrintSensor;
      rules.auth = {
        inherit fprintd-only-if-lid-open;
        # Cap the fingerprint wait so a wedged sensor can never block the
        # fall-through to password auth.
        fprintd.settings.timeout = 60;
      };
    };
    login.fprintAuth = false;
    gdm.fprintAuth = false;
    kde.fprintAuth = false;
  };
}
