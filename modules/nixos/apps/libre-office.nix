{pkgs-stable, ...}: {
  environment.systemPackages = with pkgs-stable; [
    libreoffice-qt
    hunspell
    hunspellDicts.en_US
  ];
}
