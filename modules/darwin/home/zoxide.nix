# zoxide comes from Homebrew (see ../homebrew.nix). Render its nushell init at
# build time and source it from nushell.nix — early, so the zc/zic helpers can
# call zoxide's internal __zoxide_z/__zoxide_zi. The init invokes `zoxide` by
# name, so at runtime the Homebrew binary on PATH is what's used.
{pkgs, ...}: {
  home.file."Library/Application Support/nushell/zoxide-init.nu".source =
    pkgs.runCommand "zoxide-init.nu" {} ''
      ${pkgs.lib.getExe pkgs.zoxide} init nushell > $out
    '';
}
