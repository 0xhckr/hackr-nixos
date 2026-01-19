{
  config,
  ...
}: {
  programs.gamescope = {
    enable = builtins.elem config.networking.hostName ["hackrfrmw" "hackrpc"];
    capSysNice = true;
  };
}
