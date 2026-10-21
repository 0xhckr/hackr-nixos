{ inputs, username, ... }: {
  imports = [ inputs.rex.nixosModules.default ];

  services.rex.loginServer = {
    enable = true;
    accounts.${username}.principals = [ "tailscale:0xhckr@github" ];
    tailscaleServe.enable = true;
  };
}
