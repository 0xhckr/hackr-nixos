{
  inputs,
  system,
  pkgs,
  ...
}:
let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      inherit system;
    };
    users = {
      "hackr" = if isLinux then import ./linux.nix else import ./macos.nix;
    };
    backupFileExtension = "bak";
  };
}
