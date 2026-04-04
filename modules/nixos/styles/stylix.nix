{
  inputs,
  lib,
  pkgs-stable,
  ...
}: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];
  stylix = {
    enable = true;
    base16Scheme = ./themes/rose-pine.yaml;
    polarity = "dark";
    targets.qt.platform = lib.mkForce "qtct";
    cursor = {
      package = pkgs-stable.rose-pine-cursor;
      name = "BreezeX-RosePine-Linux";
      size = 16;
    };
  };
}
