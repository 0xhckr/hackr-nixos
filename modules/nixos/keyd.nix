{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    keyd
  ];

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        extraConfig = ''
          [main]
          
          [meta]
          c = C-c
          b = C-b
          v = C-v
          x = C-x
          a = C-a
          f = C-f
          t = C-t
          r = C-r
          s = C-s
          w = C-w
          n = C-n
          k = C-k
          l = C-l
          o = C-o
          p = C-p
          [ = C-[
          ] = C-]
          z = C-z
          , = C-,
          left = home
          right = end
          up = C-home
          down = C-end
          backspace = macro(space S-home backspace left)
          delete = macro(space left S-end delete)
          minus = C-minus
          equal = C-equal
          / = C-slash
          enter = C-enter
          . = C-.

          [meta+shift]
          s = M-S-s

          [meta+alt]
          up = M-A-up
          down = M-A-down

          [alt]
          left = C-left
          right = C-right
          backspace = C-backspace
          delete = C-delete

          [meta+control]
          left = M-C-left
          right = M-C-right
          up = M-C-up
          down = M-C-down
          z = M-C-z
          equal = M-C-equal
          minus = M-C-minus

          [meta+control+shift]
          f = M-C-S-f
        '';
      };
    };
  };
}