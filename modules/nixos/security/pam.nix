{...}: {
  security = {
    sudo.enable = true;
    rtkit.enable = true;
    
    pam.services = {
      "1password".unixAuth = true;
      "polkit-1".unixAuth = true;
      "sudo".unixAuth = true;
      login = {
        unixAuth = true;
        enableGnomeKeyring = true;
      };
      gdm.unixAuth = true;
      kde.unixAuth = true;
    };
  };
}
