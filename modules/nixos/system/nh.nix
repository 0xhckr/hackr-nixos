{
  inputs,
  system,
  username,
  ...
}: {
  environment.systemPackages = [
    inputs.nh.packages.${system}.default
  ];
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 3d --keep 3";
    flake = "/home/${username}/nixos";
  };
}
