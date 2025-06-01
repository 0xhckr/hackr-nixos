{
  config,
  pkgs,
  ...
}:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  hardware.xone.enable = true;
  services.getty.autologinUser = "hackr";
  environment = {
    systemPackages = with pkgs; [
      mangohud
      steam-run
    ];
    loginShellInit = ''
      [[ "$(tty)" = "/dev/tty1" ]] && ./gs.sh
    '';
  };

  nixpkgs.config.allowUnfree = true;
}
