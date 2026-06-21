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
    base16Scheme = ./themes/pierre-dark.yaml;
    polarity = "dark";
    targets.qt.platform = lib.mkForce "qtct";
    # Stylix's kmscon target still uses services.kmscon.{extraConfig,fonts},
    # removed in nixpkgs. We don't use kmscon, so disable the target.
    targets.kmscon.enable = false;
    cursor = {
      package = pkgs-stable.rose-pine-cursor;
      name = "BreezeX-RosePine-Linux";
      size = 16;
    };
  };
}
