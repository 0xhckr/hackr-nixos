# herdr (agent multiplexer) is in Homebrew, but install it from its flake to
# match the pinned version used on Linux and keep both platforms in sync.
{
  inputs,
  system,
  ...
}: {
  home.packages = [inputs.herdr.packages.${system}.default];
}
