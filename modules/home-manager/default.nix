{
  inputs,
  system,
  config,
  username,
  fullName,
  pkgs-fresh,
  pkgs-stable,
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
      inherit pkgs-fresh;
      inherit pkgs-stable;
      hostname = config.networking.hostName;
    };
    users = {
      ${username} = import ./links.nix;
    };
    backupFileExtension = "bak";
  };
}
