{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    kdePackages.kwallet
  ];

  security.pam.services = {
    "1password".kwallet = {
      enable = true;
      forceRun = true;
    };
    "polkit-1".kwallet = {
      enable = true;
      forceRun = true;
    };
  };
}
