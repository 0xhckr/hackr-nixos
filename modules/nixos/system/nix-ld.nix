{ pkgs, ... }:
{
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    openssl
    zlib
    fuse3
    icu
    nss
    curl
    expat
  ];
}
