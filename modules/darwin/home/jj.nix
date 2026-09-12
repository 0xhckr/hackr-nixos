# jj (jujutsu) config. jj itself comes from Homebrew (see ../homebrew.nix) and
# reads ~/.config/jj/config.toml on macOS.
{
  inputs,
  system,
  ...
}: {
  home.file.".config/jj/config.toml" = {
    source = ../../../ssh/darwin.jj-config.toml;
    force = true;
  };
}
