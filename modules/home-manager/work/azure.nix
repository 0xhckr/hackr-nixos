{
  pkgs,
  ...
}: let
  azure-cli = pkgs.azure-cli.withExtensions [
    pkgs.azure-cli-extensions.azure-devops
    pkgs.azure-cli-extensions.ssh
  ];
in {
  home.packages = [azure-cli];
}
