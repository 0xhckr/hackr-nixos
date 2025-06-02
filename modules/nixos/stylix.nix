{ pkgs, ... }:
{
  stylix.enable = true;
  stylix.base16Scheme = ./oscura-midnight.yaml;
  stylix.polarity = "dark";
  stylix.cursor.package = pkgs.rose-pine-cursor;
  stylix.cursor.name = "BreezeX-RosePine-Linux";

}
