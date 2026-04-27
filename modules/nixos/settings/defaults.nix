{
  pkgs-stable,
  username,
  ...
}: {
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.networkmanager.enable = true; # enable network manager
  time.timeZone = "America/Edmonton"; # set timezone
  i18n.defaultLocale = "en_CA.UTF-8"; # set locale
  services.xserver.enable = true; # enables x11
  services.fwupd.enable = true; # enable firmware updates
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  nixpkgs.overlays = [
    (final: prev: {
      openssh = prev.openssh.overrideAttrs (old: {
        patches = (old.patches or []) ++ [../../../patches/openssh.patch];
        doCheck = false;
      });
    })
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      extra-substituters = [
        "https://helios.0xhckr.dev/main"
        "https://zed.cachix.org"
        "https://cache.garnix.io"
      ];
      extra-trusted-public-keys = [
        "helios.0xhckr.dev-1:1gis19Y+dRc3x390N57mAJWzyDSKO+FL+7H+GBplvUA="
        "zed.cachix.org-1:/pHQ6dpMsAZk2DiP4WCL0p9YDNKWj2Q5FL20bNmw1cU="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };
  };
  # Basic packages used everywhere
  environment.systemPackages = with pkgs-stable; [
    wget
    curl
  ];

  users.users.${username}.extraGroups = ["networkmanager" "wheel"];

  # Enable CUPS to print documents.
  services.printing.enable = true;
}
