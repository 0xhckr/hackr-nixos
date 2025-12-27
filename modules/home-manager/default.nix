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
      "hackr" = import ./links.nix;
    };
    backupFileExtension = "bak";
  };
}
