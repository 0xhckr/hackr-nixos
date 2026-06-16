# Docker via colima + the docker CLI (see ../homebrew.nix for the brews).
# colima runs a lightweight Lima VM hosting the Docker daemon; the `docker`
# CLI talks to it over the auto-created "colima" docker context. This module
# handles the two pieces Homebrew leaves manual:
#
#   1. `docker compose` (v2) is a CLI plugin. Homebrew installs the binary but
#      Docker only finds plugins in its search dirs. Rather than edit
#      ~/.docker/config.json (which docker/colima also write to), we symlink the
#      compose binary into ~/.docker/cli-plugins/, a default plugin dir. The
#      standalone `docker-compose` command keeps working regardless.
#
#   2. Autostart on login via a launchd agent running `colima start --foreground`
#      (the same invocation `brew services` uses), so the daemon is up in every
#      shell without a manual `colima start`.
{config, ...}: let
  brewPrefix = "/opt/homebrew";
in {
  home.file.".docker/cli-plugins/docker-compose".source =
    config.lib.file.mkOutOfStoreSymlink "${brewPrefix}/bin/docker-compose";

  launchd.agents.colima = {
    enable = true;
    config = {
      ProgramArguments = [
        "${brewPrefix}/bin/colima"
        "start"
        "--foreground"
      ];
      RunAtLoad = true;
      # Restart if the VM process dies unexpectedly, but not after a clean
      # `colima stop` (which exits 0).
      KeepAlive.SuccessfulExit = false;
      StandardOutPath = "/tmp/colima.log";
      StandardErrorPath = "/tmp/colima.err.log";
      # launchd starts with a bare PATH; colima needs limactl et al. from brew.
      EnvironmentVariables.PATH = "${brewPrefix}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
    };
  };
}
