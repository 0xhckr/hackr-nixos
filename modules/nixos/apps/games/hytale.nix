{
  system,
  inputs,
  ...
}: {
  environment.systemPackages = [
    inputs.hytale.packages.${system}.default
  ];
}
