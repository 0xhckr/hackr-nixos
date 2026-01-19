{
  config,
  pkgs,
  ...
}: let
  isFrmw = config.networking.hostName == "hackrfrmw";
in {
  environment.systemPackages = with pkgs; [
    fprintd
    polkit_gnome
    kdePackages.kwallet
    hyprpolkitagent
  ];

  services.fprintd = {
    enable = isFrmw;
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

  security = {
    sudo.enable = true;
    rtkit.enable = true;
    pam.services = {
      "1password" = {
        fprintAuth = isFrmw;
        unixAuth = true;
        kwallet = {
          enable = true;
          forceRun = true;
        };
      };
      "polkit-1" = {
        fprintAuth = isFrmw;
        unixAuth = true;
        kwallet = {
          enable = true;
          forceRun = true;
        };
      };
      "sudo" = {
        fprintAuth = isFrmw;
        unixAuth = true;
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
