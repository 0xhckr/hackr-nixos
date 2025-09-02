# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    inputs.home-manager.nixosModules.default
    ./hardware-configuration.nix
    ../../modules/nixos/defaults.nix
    ../../modules/nixos/sound.nix
    ../../modules/nixos/user-cfg.nix
    ../../modules/nixos/gnome.nix
    ../../modules/nixos/niri.nix
    ../../modules/nixos/fonts.nix
    ../../modules/nixos/stylix.nix
    ../../modules/nixos/steam.nix
    ../../modules/nixos/docker.nix
    ../../modules/nixos/keyd.nix
    ../../modules/nixos/tailscale.nix
    ../../modules/nixos/fw.nix
    ../../modules/nixos/dev.nix
    ../../modules/nixos/netbird.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.hostName = "hackrwork"; # Define your hostname.

  environment.systemPackages = with pkgs; [
    # add global basic packages here (the ones that are used quite literally everywhere)
    wget
    curl
    openrazer-daemon
    polychromatic
  ];
  hardware.openrazer.enable = true;
  users.users.hackr.extraGroups = [ "openrazer" ];

  services.logind.lidSwitchExternalPower = "ignore";
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
