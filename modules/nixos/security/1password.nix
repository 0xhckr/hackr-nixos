{
  pkgs-fresh,
  username,
  ...
}: {
  programs._1password-gui = {
    enable = true;
    package = pkgs-fresh._1password-gui;
    polkitPolicyOwners = [username];
  };
}
