{ pkgs, lib, ... }:
let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hackr = if isLinux then {
    isNormalUser = true;
    description = "Mohammad Al-Ahdal";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.nushell;
  } else {
    description = "Mohammad Al-Ahdal";
    home = "/Users/hackr";
    shell = pkgs.nushell;
  };

  # Enable automatic login for the user.
  services = if isLinux then {
    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "hackr";
  } else {};
}
