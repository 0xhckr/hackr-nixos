{
  inputs,
  system,
  config,
  ...
}:
{
  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      inherit system;
      hostname = config.networking.hostName;
    };
    users = {
      "hackr" = import ./linux.nix;
    };
    backupFileExtension = "bak";
  };
}
