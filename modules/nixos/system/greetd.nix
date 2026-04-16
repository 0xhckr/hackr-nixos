{
  lib,
  inputs,
  system,
  username,
  ...
}: {
  services.xserver.enable = true;

  services.displayManager.gdm.enable = lib.mkForce false;

  services.greetd = {
    enable = true;

    settings = {
      terminal.vt = 1;

      default_session = {
        user = "greeter";
        command = lib.concatStringsSep " " [
          (lib.getExe inputs.tuigreet.packages.${system}.tuigreet)
          "--time"
          "--remember"
          "--asterisks"
          "--user-menu"
          "--sessions"
          "/run/current-system/sw/share/wayland-sessions"
          "--xsessions"
          "/run/current-system/sw/share/xsessions"
          "--user"
          username
          "--cmd"
          "niri"
        ];
      };
    };
  };

  users.groups.greeter = {};
  users.users.greeter = {
    isSystemUser = true;
    group = "greeter";
    home = "/var/lib/greetd";
    createHome = true;
  };

  systemd.tmpfiles.rules = [
    "d /var/cache/tuigreet 0755 greeter greeter -"
  ];

  security.pam.services.greetd = {
    unixAuth = true;
    enableGnomeKeyring = true;
  };

  systemd.services."getty@tty1".enable = lib.mkDefault false;
  systemd.services."autovt@tty1".enable = lib.mkDefault false;
}
