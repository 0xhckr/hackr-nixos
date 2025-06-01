{ pkgs, lib, ... }:
let
  no-rgb = pkgs.writeScriptBin "no-rgb" ''
    #!/bin/sh
    NUM_DEVICES=$(${pkgs.openrgb}/bin/openrgb --noautoconnect --list-devices | grep -E '^[0-9]+: ' | wc -l)

    for i in $(seq 0 $(($NUM_DEVICES - 1))); do
      ${pkgs.openrgb-with-all-plugins}/bin/openrgb --noautoconnect --device $i --mode static --color 000000
    done
  '';
in
{
  config = {
    services.hardware.openrgb.enable = true;
    environment.systemPackages = with pkgs; [ openrgb-with-all-plugins ];
    services.udev.packages = [ pkgs.openrgb-with-all-plugins ];
    boot.kernelModules = [ "i2c-dev" ];
    hardware.i2c.enable = true;

    systemd.services.no-rgb = {
      description = "no-rgb";
      serviceConfig = {
        ExecStart = "${no-rgb}/bin/no-rgb";
        Type = "oneshot";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
