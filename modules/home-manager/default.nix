{ inputs, system, ... }:
{
  home-manager = {
    extraSpecialArgs = { inherit inputs; inherit system; };
    users = {
      "hackr" = import ./home.nix;
    };
    backupFileExtension = "bak";
  };
}
