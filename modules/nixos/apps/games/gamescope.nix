{config, ...}: {
  programs.gamescope = {
    enable = builtins.elem config.networking.hostName ["torchick" "infernape"];
    capSysNice = true;
  };
}
