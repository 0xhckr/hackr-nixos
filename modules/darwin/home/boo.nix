# boo (coder/boo) — screen-style terminal multiplexer built on libghostty.
# Not in Homebrew, so install it from its flake. Ships an aarch64-darwin
# package, mirroring how the NixOS hosts pull it in via the terminal module.
{
  inputs,
  system,
  ...
}: {
  home.packages = [inputs.boo.packages.${system}.default];
}
