{
  config,
  pkgs,
  ...
}: let
  isTorchick = config.networking.hostName == "torchick";
in {
  environment.systemPackages = with pkgs; [
    fprintd
    polkit_gnome
    kdePackages.kwallet
    hyprpolkitagent
  ];

  services.fprintd = {
    enable = isTorchick;
    tod.driver = pkgs.libfprint-2-tod1-vfs0090;
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["hackr"];
  };

  security = let
    fprintd-only-if-lid-open = {
      enable = isTorchick;
      order = 0;
      control = "[success=ok default=1]";
      modulePath = "${config.security.pam.package}/lib/security/pam_exec.so";
      args = [
        "quiet"
        "quiet_log"
        "${pkgs.writeShellScript "is-lid-open" ''
          # this script exits with exit code 1 if anything goes wrong or the lid is closed; returns 0 if lid is open

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
    sudo.enable = true;
    rtkit.enable = true;
    pam.services = {
      "1password" = {
        fprintAuth = isTorchick;
        unixAuth = true;
        kwallet = {
          enable = true;
          forceRun = true;
        };
        rules.auth = {
          inherit fprintd-only-if-lid-open;
        };
      };
      "polkit-1" = {
        fprintAuth = isTorchick;
        unixAuth = true;
        kwallet = {
          enable = true;
          forceRun = true;
        };
        rules.auth = {
          inherit fprintd-only-if-lid-open;
        };
      };
      "sudo" = {
        fprintAuth = isTorchick;
        unixAuth = true;
        rules.auth = {
          inherit fprintd-only-if-lid-open;
        };
      };
      login = {
        fprintAuth = false;
        unixAuth = true;
        enableGnomeKeyring = true;
      };
      gdm = {
        fprintAuth = false;
        unixAuth = true;
      };
      kde = {
        fprintAuth = false;
        unixAuth = true;
      };
    };
  };
}
