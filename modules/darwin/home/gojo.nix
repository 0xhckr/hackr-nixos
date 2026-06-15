# gojo isn't in Homebrew, so build it from its flake source.
#
# WORKAROUND: upstream (0xhckr/gojo) hardcodes a single bun-deps outputHash that
# only matches on Linux. bun resolves platform-specific packages, so the deps
# hash differs on aarch64-darwin. Until upstream makes that hash platform-aware,
# we rebuild the package here (identical logic) with a per-platform hash.
#
# Once gojo's flake is fixed, replace this whole file's body with:
#   home.packages = [inputs.gojo.packages.${system}.default];
{
  inputs,
  system,
  pkgs,
  ...
}: let
  version = "0.1.0";
  src = inputs.gojo;

  bunDepsHash =
    {
      aarch64-darwin = "sha256-40QDCyEcBA8rZBohxlq/CF5VWaVSIIBMS+NwElzqPmY=";
      x86_64-linux = "sha256-xbBgYVWdM12f3I7FQPB+6mGvRm5FGoNStPC2iYp4kOA=";
    }
    .${system};

  bunDeps = pkgs.stdenv.mkDerivation {
    name = "gojo-${version}-bun-deps";
    inherit src;
    nativeBuildInputs = [pkgs.bun];
    dontBuild = true;
    dontFixup = true;
    installPhase = ''
      export HOME=$TMPDIR
      bun install --frozen-lockfile --no-save --ignore-scripts
      cp -r node_modules $out
    '';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = bunDepsHash;
  };

  gojo = pkgs.stdenv.mkDerivation {
    pname = "gojo";
    inherit version src;
    nativeBuildInputs = [pkgs.bun];
    configurePhase = ''
      cp -r ${bunDeps} node_modules
      chmod -R u+w node_modules
    '';
    buildPhase = ''
      export HOME=$TMPDIR
      bun build --compile src/main.tsx --outfile gojo
    '';
    dontStrip = true;
    installPhase = ''
      mkdir -p $out/bin
      install -m755 gojo $out/bin/gojo
      ln -s gojo $out/bin/gj
    '';
  };
in {
  home.packages = [gojo];
}
