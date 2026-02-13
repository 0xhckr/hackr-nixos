{
  inputs,
  system,
  config,
  username,
  fullName,
  email,
  ...
}: {
  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      inherit system;
      inherit username;
      inherit fullName;
      inherit email;
      hostname = config.networking.hostName;
    };
    users = {
      ${username} = import ./links.nix;
    };
    backupFileExtension = "bak";
  };
}
