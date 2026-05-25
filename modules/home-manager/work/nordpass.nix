{pkgs, ...}: {
  home.packages = with pkgs; [
    nordpass
  ];
}
