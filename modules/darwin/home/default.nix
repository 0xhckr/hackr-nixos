# Home-manager config for the macOS user. This is where dotfiles are managed.
{username, ...}: {
  imports = [
    ./nushell.nix
    ./starship.nix
    ./zoxide.nix
    ./fastfetch.nix
    ./gojo.nix
    ./git.nix
    ./jj.nix
    ./ssh.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/Users/${username}";
    stateVersion = "26.11";
  };

  programs.home-manager.enable = true;

  # nix-darwin manages /etc/zshrc; let home-manager own the user's zsh so the
  # direnv hook below actually gets sourced.
  programs.zsh.enable = true;

  # Install direnv + nix-direnv and register the shell hook.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };
}
