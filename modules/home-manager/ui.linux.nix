{ pkgs, inputs, lib, ... }:
{

  imports = [
    inputs.ags.homeManagerModules.default
    inputs.vicinae.homeManagerModules.default
    inputs.mango.hmModules.mango
    # inputs.dms.homeModules.dankMaterialShell.default
    # inputs.dms.homeModules.dankMaterialShell.niri
  ];

  home.packages =
    with pkgs;
    [
      cava
      wofi
      waypaper
      waybar
      playerctl
      brightnessctl
      wlogout
      wf-recorder
      slurp
      hyprpicker
      wl-clipboard
      pavucontrol
      pulseaudioFull
      alsa-utils
      swaybg
    ]
    ++ (with inputs; [
      awww.packages.${system}.default
      quickshell.packages.${system}.default
      astal.packages.${system}.default
      caelestia.packages.${system}.default
      noctalia.packages.${system}.default
    ]);

  # programs.dankMaterialShell.enable = true;

  services.vicinae = {
    enable = true;
    autoStart = true;
  };

  systemd.user.services.vicinae = {
    Service.Environment = lib.mkForce [ "USE_LAYER_SHELL=0" ];
    Service.EnvironmentFile = lib.mkForce [];
  };

  wayland.windowManager.mango = {
    enable = true;
    settings = ''
      blur=1
      blur_layer=1
      blur_optimized=0
      blur_params_radius=32
      blur_params_noise=0.02

      shadows=0
      animations=1
      layer_animations=0
      animation_duration_move=150
      animation_duration_open=150
      animation_duration_tag=150
      animation_duration_close=150
      drag_tile_to_tile=1
      cursor_theme=BreezeX-RosePine-Linux
      repeat_delay=150
      repeat_rate=50
      accel_profile=0

      unfocused_opacity=0.5
      focused_opacity=0.9

      border_radius=16
      borderpx=2
      bordercolor=0x00000080
      focuscolor=0x003c3c80

      bind=super+shift,space,spawn,wofi --show drun
      bind=super,space,spawn,vicinae toggle
      bind=super+ctrl,l,spawn,wlogout

      bind=none,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+
      bind=none,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-
      bind=none,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bind=none,XF86AudioMicMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      bind=none,XF86AudioPlay,spawn,playerctl play-pause
      bind=none,XF86AudioPause,spawn,playerctl play-pause
      bind=none,XF86AudioNext,spawn,playerctl next
      bind=none,XF86AudioPrev,spawn,playerctl previous

      bind=super,q,killclient

      bind=super,code:23,toggleoverview
      ov_tab_mode=1

      bind=super+ctrl,equal,increase_proportion "0.025"
      bind=super+ctrl,minus,increase_proportion "-0.025"

      bind=super+ctrl,q,quit
      bind=ctrl+shift,R,reload_config

      bind=ctrl+super,space,togglefloat

      mousebind=super,btn_left,moveresize,curmove
      mousebind=super,btn_right,moveresize,curresize

      axisbind=super,up,focusdir,left
      axisbind=super,down,focusdir,right
    '';
    autostart_sh = ''
      #! /usr/bin/env bash
      set +e
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
      vicinae server 2>&1 > /dev/null &
      qs -p /home/hackr/.config/beepshell 2>&1 > /dev/null &
      /home/hackr/.config/niri/delayed 2>&1 > /dev/null &
      tailscale-systray 2>&1 > /dev/null &
    '';
  };
}
