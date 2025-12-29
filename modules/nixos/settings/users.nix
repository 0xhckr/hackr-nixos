{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.default
    ../../home-manager/default.nix
  ];
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hackr = {
    isNormalUser = true;
    description = "Mohammad Al-Ahdal";
    shell = pkgs.nushell;
    openssh.authorizedKeys.keyFiles = [
      ../../../ssh/authorized_keys
    ];
  };

  # Enable automatic login for the user.
  services = {
    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "hackr";
  };
}
