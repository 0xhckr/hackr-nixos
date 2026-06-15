# Shared nix-darwin base. Mirrors modules/nixos but for macOS hosts.
# Kept small on purpose — most user-facing config lives in home-manager.
{
  inputs,
  system,
  username,
  fullName,
  email,
  ...
}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

  nixpkgs.hostPlatform = system;
  nixpkgs.config.allowUnfree = true;

  # Enable flakes + the new CLI for `darwin-rebuild --flake`.
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Required by nix-darwin whenever user-scoped options (incl. home-manager)
  # are in play, so it knows which user to apply them for.
  system.primaryUser = username;

  # References the existing macOS account; nix-darwin won't create it.
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  # Manage the login shell's /etc/zshrc so nix + the direnv hook load.
  programs.zsh.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    extraSpecialArgs = {
      inherit inputs system username fullName email;
    };
    users.${username} = import ./home.nix;
  };
}
