{config, ...}: {
  programs.gamescope = {
    enable = builtins.elem config.networking.hostName ["infernape" "flareon"];
    capSysNice = true;
  };
}
