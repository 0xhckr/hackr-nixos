# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{pkgs, username, ...}: {
  imports = [
    ../../modules/nixos
    ../../modules/nixos/hardware/snorlax-nvidia.nix
    ../../modules/nixos/hardware/snorlax-openrazer.nix
    ../../modules/nixos/hardware/snorlax-power-management.nix
    ./hardware-configuration.nix
    ./boot.nix
  ];

  networking.hostName = "snorlax"; # Define your hostname.

  # User group for openrazer - kept here as it's user-specific
  users.users.${username}.extraGroups = ["openrazer"];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
