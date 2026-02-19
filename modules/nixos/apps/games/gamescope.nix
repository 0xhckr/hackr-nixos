{config, ...}: {
  programs.gamescope = {
    enable = builtins.elem config.networking.hostName ["torchic" "infernape"];
    capSysNice = true;
  };
}
