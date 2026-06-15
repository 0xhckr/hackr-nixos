# jj (jujutsu) config. jj itself comes from Homebrew (see ../homebrew.nix) and
# reads ~/.config/jj/config.toml on macOS. The configured pager is `hunk`,
# which isn't in Homebrew, so install it from its flake.
{
  inputs,
  system,
  ...
}: {
  home.file.".config/jj/config.toml" = {
    source = ../../../ssh/darwin.jj-config.toml;
    force = true;
  };

  home.packages = [inputs.hunk.packages.${system}.default];
}
