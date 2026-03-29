{pkgs-stable, ...}: {
  fonts.packages = with pkgs-stable; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts._0xproto
    nerd-fonts.departure-mono
    (google-fonts.override {
      fonts = [
        "DM Sans"
        "DM Mono"
        "DM Serif Display"
        "DM Sans Display"
        "Cairo"
        "Zain"
      ];
    })
  ];
}
