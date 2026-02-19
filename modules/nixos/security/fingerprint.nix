{config, pkgs, ...}: let
  istorchic = config.networking.hostName == "torchic";
in {
  # Fingerprint authentication (torchic-specific)
  services.fprintd = {
    enable = istorchic;
    tod.driver = pkgs.libfprint-2-tod1-vfs0090;
  };

  environment.systemPackages = with pkgs; [
    fprintd
  ];

  # Only enable fingerprint auth when lid is open
  security.pam.services = let
    fprintd-only-if-lid-open = {
      enable = istorchic;
      order = 0;
      control = "[success=ok default=1]";
      modulePath = "${config.security.pam.package}/lib/security/pam_exec.so";
      args = [
        "quiet"
        "quiet_log"
        "${pkgs.writeShellScript "is-lid-open" ''
          set -eoui pipefail
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
      fprintAuth = istorchic;
      rules.auth = { inherit fprintd-only-if-lid-open; };
    };
    "polkit-1" = {
      fprintAuth = istorchic;
      rules.auth = { inherit fprintd-only-if-lid-open; };
    };
    "sudo" = {
      fprintAuth = istorchic;
      rules.auth = { inherit fprintd-only-if-lid-open; };
    };
    login.fprintAuth = false;
    gdm.fprintAuth = false;
    kde.fprintAuth = false;
  };
}
