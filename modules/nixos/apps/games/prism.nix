{pkgs-fresh, ...}: {
  environment.systemPackages = with pkgs-fresh; [
    prismlauncher
  ];
}
