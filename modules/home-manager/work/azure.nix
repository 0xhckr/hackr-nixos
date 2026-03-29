{pkgs-stable, ...}: let
  pkgs = pkgs-stable;
  azure-cli = pkgs.azure-cli.withExtensions (with pkgs.azure-cli-extensions; [
    azure-devops
    ssh
  ]);
in {
  home.packages = [azure-cli];
}
