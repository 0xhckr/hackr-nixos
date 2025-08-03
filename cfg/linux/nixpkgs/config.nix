{
  packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball {
      url = "https://github.com/nix-community/NUR/archive/6f2328a65015c49b8d571f7e64867edd107c854c.tar.gz";
      sha256 = "15njf1z2s5hirmymlydy5hc8isvd181nkv7irid74lf236f8kxjz";
    }) {
      inherit pkgs;
    };
  };
}