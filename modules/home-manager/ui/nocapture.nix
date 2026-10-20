{
  inputs,
  system,
  ...
}:
let
  package = inputs.nocapture.packages.${system}.default;
in
{
  home.packages = [ package ];

  xdg.dataFile."noctalia/plugins/nocapture".source = "${package}/share/noctalia/plugins/nocapture";
}
