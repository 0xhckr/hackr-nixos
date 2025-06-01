{ pkgs, ... }:
{
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
  stylix.polarity = "dark";
  stylix.cursor.package = pkgs.rose-pine-cursor;
  stylix.cursor.name = "BreezeX-RosePine-Linux";

}
