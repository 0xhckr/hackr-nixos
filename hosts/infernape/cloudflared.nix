{pkgs, ...}: {
  # Dashboard-managed tunnel: oc.hackrlabs.dev -> http://127.0.0.1:49374.
  # The pinned NixOS cloudflared module only supports locally managed tunnels.
  systemd.services.cloudflared-infernape = {
    description = "Cloudflare Tunnel for infernape";
    wantedBy = ["multi-user.target"];
    wants = ["network-online.target"];
    after = ["network-online.target"];

    serviceConfig = {
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token-file %d/tunnel-token";
      LoadCredential = "tunnel-token:/var/lib/cloudflared/infernape-token";
      DynamicUser = true;
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
