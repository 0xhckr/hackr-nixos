# fastfetch comes from Homebrew (see ../homebrew.nix). pokeget-rs (the Rust
# rewrite of pokeget) isn't in Homebrew, so install it from nix — it provides
# the `pokeget` binary used by the `pokefetch` helper in nushell.nix.
{pkgs, ...}: {
  home.packages = [pkgs.pokeget-rs];

  home.file.".config/fastfetch" = {
    source = ../../../cfg/fastfetch;
    recursive = true;
    force = true;
  };
}
