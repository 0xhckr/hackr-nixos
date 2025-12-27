{ inputs, pkgs, ... }:
{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];
  stylix.enable = true;
  stylix.base16Scheme = ./themes/poimandres.yaml;
  stylix.polarity = "dark";
  stylix.cursor.package = pkgs.rose-pine-cursor;
  stylix.cursor.name = "BreezeX-RosePine-Linux";
  stylix.cursor.size = 16;
}
