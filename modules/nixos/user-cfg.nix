{ pkgs, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hackr = {
    isNormalUser = true;
    description = "Mohammad Al-Ahdal";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.nushell;
  };

  # Enable automatic login for the user.
  services = {
    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "hackr";
  };
}
