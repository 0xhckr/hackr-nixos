{ inputs, ... }:
{
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.networkmanager.enable = true; # enable network manager
  time.timeZone = "America/Edmonton"; # set timezone
  i18n.defaultLocale = "en_CA.UTF-8"; # set locale
  services.xserver.enable = true; # enables x11
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  nixpkgs.overlays = [
    (final: prev: {
      openssh = prev.openssh.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ../../patches/openssh.patch ];
        doCheck = false;
      });
    })
    inputs.nur.overlays.default
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball {
      url = "https://github.com/nix-community/NUR/archive/6f2328a65015c49b8d571f7e64867edd107c854c.tar.gz";
      sha256 = "15njf1z2s5hirmymlydy5hc8isvd181nkv7irid74lf236f8kxjz";
    }) {
      inherit pkgs;
    };
  };

  nix = {
    settings = {
      extra-substituters = [
        "https://cache.0xhckr.dev/nix-cache/"
      ];
      extra-trusted-public-keys = [
        "cache.0xhckr.dev-1:VTJYAGKFg8G5O7ia2HlJ4dDhgqoGgyq+ItpOr+UGSYw="
      ];
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
}
