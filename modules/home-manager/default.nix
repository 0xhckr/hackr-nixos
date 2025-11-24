{
  inputs,
  system,
  ...
}:
{
  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      inherit system;
    };
    users = {
      "hackr" = import ./linux.nix;
    };
    backupFileExtension = "bak";
  };
}
