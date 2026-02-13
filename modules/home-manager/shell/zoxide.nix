{...}: {
  programs.zoxide = {
    enable = true;
    # we enable zoxide in our own config file but we need to do so earlier so that our helper zc and zic functions work.
    enableNushellIntegration = false;
  };
}
