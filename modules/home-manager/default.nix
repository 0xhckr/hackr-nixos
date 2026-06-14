{
  inputs,
  system,
  config,
  username,
  fullName,
  pkgs-fresh,
  pkgs-stable,
  x86_systems,
  aarch64_systems,
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
      inherit x86_systems;
      inherit aarch64_systems;
      hostname = config.networking.hostName;
    };
    users = {
      ${username} = import ./links.nix;
    };
    backupFileExtension = "bak";
  };
}
