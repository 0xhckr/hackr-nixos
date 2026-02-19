{
  config,
  pkgs,
  username,
  ...
}: {
  programs.steam = {
    enable = builtins.elem config.networking.hostName ["torchic" "infernape"];
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
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
