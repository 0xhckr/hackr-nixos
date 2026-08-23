{
  pkgs,
  config,
  username,
  ...
}: {
  programs.steam = {
    enable = builtins.elem config.networking.hostName ["torchic" "infernape" "flareon"];
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
    # pkgs (unstable), not pkgs-stable: stable's FHS profile ships libdrm 2.4.129
    # while stable mesa 26.2.1 needs 2.4.134 -> radeonsi/radv fail to load under
    # steam's LD_LIBRARY_PATH -> "glXChooseVisual failed" fatal assert at launch.
    package = pkgs.steam;
  };
  hardware.xone.enable = true;
  services.getty.autologinUser = username;
  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = with pkgs; [
      mangohud
      steam-run
    ];
    loginShellInit = ''
      [[ "$(tty)" = "/dev/tty1" ]] && ./gs.sh
    '';
  };
}
