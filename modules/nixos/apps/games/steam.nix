{ config, pkgs, ... }:
{
  programs.steam = {
    enable = builtins.elem config.networking.hostName [ "hackrfrmw" "hackrpc" ];
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
  };
  hardware.xone.enable = true;
  services.getty.autologinUser = "hackr";
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