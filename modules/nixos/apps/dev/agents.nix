{
  inputs,
  lib,
  pkgs,
  system,
  ...
}: let
  # OpenTUI dlopens Wayland for clipboard images; wl-clipboard alone is not enough.
  opencode2 = inputs.llm-agents.packages.${system}.opencode2.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      wrapProgram "$out/bin/opencode2" \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [pkgs.wayland]}
    '';
  });
in {
  environment.systemPackages = with inputs.llm-agents.packages."${system}"; [
    crush
    claude-code
    cursor-agent
    opencode2
    pi
  ];
  home-manager.extraSpecialArgs = {inherit opencode2;};
  nixpkgs.config.allowUnfree = true;
}
