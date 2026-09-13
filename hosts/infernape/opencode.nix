{username, ...}: {
  users.users.${username}.linger = true;

  home-manager.users.${username} = {config, opencode2, ...}: {
    systemd.user.services.opencode = {
      Unit.Description = "OpenCode shared server";
      Install.WantedBy = ["default.target"];

      Service = {
        # Hand over any automatically spawned server to systemd.
        ExecStartPre = "${opencode2}/bin/opencode2 service stop";
        ExecStart = "${opencode2}/bin/opencode2 serve --service";
        WorkingDirectory = config.home.homeDirectory;
        Environment = ["PATH=${config.home.profileDirectory}/bin:/run/current-system/sw/bin"];
        Restart = "always";
        RestartSec = 5;
      };
    };
  };
}
