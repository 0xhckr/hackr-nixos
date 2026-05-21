{
  hostname,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (lib.optionalAttrs (hostname == "snorlax") nordpass)
  ];
}
