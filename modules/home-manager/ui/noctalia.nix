{
  inputs,
  system,
  username,
  ...
}: {
  imports = [inputs.noctalia.homeModules.default];

  # v5: no runtime colors.json anymore. The old `noctalia-shell` target only
  # wrote a static v4 palette that v5 ignores (kept off below as belt &
  # suspenders); the new `noctalia` target, however, would force a base16
  # palette + custom_palette="stylix", stylix fonts, opacity and wallpaper
  # defaults into our TOML — clobbering the Pierre palette pair and everything
  # the runtime dark/light toggle relies on. Disabled, same reason we disable
  # the gtk/gnome/vicinae targets.
  stylix.targets.noctalia-shell.enable = false;
  stylix.targets.noctalia.enable = false;

  programs.noctalia = {
    enable = true;
    package = inputs.noctalia.packages.${system}.default;

    # The attrset below is converted to TOML into ~/.config/noctalia/config.toml
    # and validated at build time (`noctalia config validate`). GUI changes made
    # at runtime are written to ~/.local/state/noctalia/settings.toml, which
    # loads AFTER config.toml and wins — if a setting here appears ignored,
    # clear the override from that state file. (No writable-copy activation
    # hack needed anymore; that was a v4 read-only-symlink workaround.)
    #
    # v4 -> v5 port notes:
    # - plugins are Luau now, addressed <author>/<plugin>; official/community
    #   sources are built in, no source declaration needed.
    # - polkit-agent is built into the shell ([shell] polkit_agent).
    # - display-settings and model-usage have no v5 equivalent (see journal).
    settings = {
      accessibility = {
        ui_scale = 1.0;
        high_contrast = false;
      };

      shell = {
        font_family = "DM Sans";
        corner_radius_scale = 1.0;
        telemetry_enabled = false;
        settings_show_advanced = true;
        # Replaces the v4 polkit-agent plugin. modules/nixos/security/polkit.nix
        # intentionally installs no standalone agent.
        polkit_agent = true;
        avatar_path = "/home/${username}/.face";
        # v4 clipboard history was off and piped through cliphist; v5 has a
        # built-in (encrypted) clipboard manager. Keeping the v4 behaviour of
        # "no clipboard history" here — flip to true to get the new one.
        clipboard_enabled = false;
        # v4 time was 24h everywhere (use12hourFormat=false).
        time_format = "{:%H:%M}";

        mpris.blacklist = []; # v4 audio.mprisBlacklist

        animation = {
          enabled = true; # v4 animationDisabled = false
          speed = 1.0;
        };

        shadow = {
          direction = "down_right"; # v4 shadowDirection "bottom_right"
          alpha = 0.55; # default; v4 enableShadows=true mapped to per-surface shadow flags
        };

        panel = {
          transparency_mode = "soft"; # ~ v4 ui.panelBackgroundOpacity 0.93 (no numeric knob in v5)
          launcher_position = "center"; # v4 appLauncher.position "center" (placement floating = default)
          control_center_placement = "attached"; # v4 ui.panelsAttachedToBar
          wallpaper_placement = "attached"; # v4 wallpaper.panelPosition "follow_bar"
          open_near_click_control_center = true; # v4 controlCenter.position "close_to_bar_button"
          session_placement = "floating";
          session_position = "center"; # v4 sessionMenu.position "center"
        };

        launcher = {
          categories = true; # v4 showCategories
          show_icons = true; # v4 iconMode "tabler" (v5 icons are tabler-style regardless)
          app_grid = false; # v4 viewMode "list"
          sort_by_usage = true; # v4 sortByMostUsed
        };

        session = {
          grid = true; # v4 largeButtonsLayout "grid"
          show_shortcuts = true; # v4 showNumberLabels
          # v4 countdown (10000ms) is per-action in v5. v4 order preserved.
          # v5 has no hibernate action — emulated with a custom command.
          actions = [
            {
              action = "lock";
              countdown_seconds = 10;
            }
            {
              action = "suspend";
              countdown_seconds = 10;
            }
            {
              action = "command";
              label = "Hibernate";
              glyph = "bedtime";
              command = "systemctl hibernate";
              countdown_seconds = 10;
            }
            {
              action = "reboot";
              countdown_seconds = 10;
              variant = "destructive";
            }
            {
              action = "logout";
              countdown_seconds = 10;
            }
            {
              action = "shutdown";
              countdown_seconds = 10;
              variant = "destructive";
            }
          ];
        };
      };

      wallpaper = {
        enabled = true;
        directory = "/home/${username}/walls";
        fill_mode = "crop";
        fill_color = "#000000";
        # `transition` omitted: v5 picks randomly from the full pool
        # (fade/wipe/disc/stripes/zoom/honeycomb) == v4 transitionType "random".
        transition_duration = 1500;
        edge_smoothness = 0.05;

        automation = {
          enabled = false; # v4 automationEnabled
          interval_seconds = 300; # v4 randomIntervalSec
          order = "random"; # v4 wallpaperChangeMode
        };
      };

      theme = {
        # Declarative baseline = dark; the control-center toggle flips it at
        # runtime and persists to the state settings.toml (same v4 semantics).
        mode = "dark";
        source = "custom";
        custom_palette = "Pierre";

        templates = {
          enable_builtin_templates = false;
          enable_community_templates = false;
        };
      };

      hooks = {
        # v4 hooks.darkModeChange. In v5 the payload is an env var:
        # NOCTALIA_THEME_MODE = dark|light (resolved), not positional $1.
        # Drives every app that follows the freedesktop appearance portal
        # (ghostty, zed, gtk/gnome) plus vicinae's pierre themes.
        theme_mode_changed = ''
          if [ "$NOCTALIA_THEME_MODE" = "dark" ]; then
            gsettings set org.gnome.desktop.interface color-scheme prefer-dark
            gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3-dark
            vicinae theme set pierre-dark || true
          else
            gsettings set org.gnome.desktop.interface color-scheme prefer-light
            gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3
            vicinae theme set pierre-light || true
          fi
        '';
      };

      notification = {
        enable_daemon = true;
        layer = "overlay"; # v4 overlayLayer
        background_opacity = 1.0;
        # (v4 was top_right = v5 default; per-urgency durations/respectExpiry
        # don't exist in v5 — sender expire_timeout is honored, else 6s.)
      };

      osd = {
        enabled = true; # v4 osd.enabled
        position = "top_right";
        background_opacity = 1.0;

        # v4 enabledTypes [0 1 2] = volume-out + volume-in + brightness.
        # Everything else stays off (v4 had no such OSDs). keyboard_layout
        # carries over v4's notifications.enableKeyboardLayoutToast.
        kinds = {
          volume = true;
          volume_output = true;
          volume_input = true;
          brightness = true;
          lock_keys = false;
          keyboard_layout = true;
          keyboard_backlight = false;
          wifi = false;
          bluetooth = false;
          power_profile = false;
          caffeine = false;
          nightlight = false;
          dnd = false;
          privacy = false;
        };
      };

      weather = {
        enabled = true;
        refresh_minutes = 30;
        unit = "metric"; # v4 useFahrenheit=false ("metric|imperial", not celsius/fahrenheit)
        effects = true; # v4 weatherShowEffects
      };

      location = {
        auto_locate = false;
        address = "Calgary, AB"; # v4 location.name (geocoded once, feeds weather + nightlight schedule)
      };

      nightlight = {
        enabled = true;
        temperature_day = 6500; # v4 dayTemp
        temperature_night = 2500; # v4 nightTemp
        force = false; # v4 forced
        # Schedule: v4 autoSchedule=true -> v5 computes sunrise/sunset from
        # [location]. (To force times instead: location.custom_schedule + sunrise/sunset.)
      };

      brightness = {
        enable_ddcutil = false; # v4 enableDdcSupport
        minimum_brightness = 0.05; # v4 enforceMinimum -- hard floor instead of v4's clamp
      };

      audio = {
        enable_overdrive = false; # v4 volumeOverdrive
        enable_sounds = false; # v4 notification/plugin sounds all off
        sound_volume = 0.5;
      };

      system.monitor = {
        enabled = true;
        cpu_poll_seconds = 1;
        gpu_poll_seconds = 3;
        memory_poll_seconds = 1;
        network_poll_seconds = 1;
        disk_poll_seconds = 30; # v4 ms values converted (loadAvg merged into cpu)
        # v4 warning/critical thresholds -> v5 activity/critical per-stat.
        cpu_usage_activity_threshold = 80;
        cpu_usage_critical_threshold = 90;
        gpu_usage_activity_threshold = 80;
        gpu_usage_critical_threshold = 90;
        gpu_temp_activity_threshold = 80;
        gpu_temp_critical_threshold = 90;
        cpu_temp_activity_threshold = 80;
        cpu_temp_critical_threshold = 90;
        ram_pct_activity_threshold = 80;
        ram_pct_critical_threshold = 90;
        swap_pct_activity_threshold = 80;
        swap_pct_critical_threshold = 90;
        disk_used_pct_activity_threshold = 80;
        disk_used_pct_critical_threshold = 90;
      };

      battery.warning_threshold = 20; # v4 batteryWarningThreshold (drives low-battery notify)

      control_center = {
        # v5 shows max 6 (flat list; no left/right split). v4 had 8:
        # kept wifi, bluetooth, wallpaper, notification, nightlight, dark_mode;
        # dropped power_profile + caffeine (swap back any of the others if wanted).
        shortcuts = [
          {type = "wifi";}
          {type = "bluetooth";}
          {type = "wallpaper";}
          {type = "notification";}
          {type = "nightlight";}
          {type = "dark_mode";}
        ];
      };

      bar.main = {
        position = "top";
        background_opacity = 0.0; # v4 backgroundOpacity=0 (transparent floating bar)
        radius = 12; # v4 frameRadius
        margin_ends = 5; # v4 marginHorizontal
        margin_edge = 5; # v4 marginVertical
        padding = 8; # v4 frameThickness
        widget_spacing = 6;
        # v4 showCapsule=true but capsuleColorKey="none" = invisible capsule ->
        # capsule widgets would be see-through anyway; plain floating bar is the
        # same look. Set capsule=true (+capsule_fill) if you want capsules back.
        capsule = false;
        reserve_space = true; # v4 displayMode always_visible
        auto_hide = false;

        start = ["workspaces"];
        center = ["active_window"];
        end = [
          "mawaqit" # ycf/mawaqit:bar (widget table below)
          "hassio" # pozzoo/hassio:status
          "tray"
          "control-center"
          "notifications"
          "battery"
          "volume"
          "brightness"
          "clock"
        ];
      };

      widget = {
        active_window = {
          display = "icon_and_text"; # v4 showIcon
          max_length = 450; # v4 maxWidth (px)
          title_scroll = "on_hover"; # v4 scrollingMode "hover"
          show_empty_label = false; # v4 hideMode "hidden"
        };

        workspaces = {
          style = "regular";
          show_labels = true;
          label_source = "id"; # v4 labelMode "index" (niri workspace numbering)
          max_label_chars = 2; # v4 characterCount
          labels_only_when_occupied = true; # v4 showLabelsOnlyWhenOccupied
          hide_when_empty = false; # v4 hideUnoccupied=false
          pill_scale = 0.6; # v4 pillSize
          focused_color = "primary";
          occupied_color = "secondary";
          empty_color = "secondary";
          urgent_color = "error";
        };

        # Bar widget entries for plugins: type = "<author>/<plugin>:<entry>".
        mawaqit = {
          type = "ycf/mawaqit:bar";
          showCountdown = false;
          hidePrayerName = true;
          showElapsed = false;
          dynamicIcon = true;
          widgetIcon = "pray";
        };

        hassio = {
          type = "pozzoo/hassio:status";
        };

        tray = {
          drawer = true; # v4 drawerEnabled
          pinned = [];
          hidden = []; # v4 blacklist
        };

        notifications.hide_when_no_unread = true; # v4 hideWhenZero

        battery = {
          display_mode = "glyph";
          show_label = true; # v4 displayMode "onhover" has no v5 equivalent -- always show
          label_content = "percent";
          device = "auto"; # v4 deviceNativePath "__default__"
        };

        volume = {
          show_label = true; # see battery note
          actions.middle = "exec pwvucontrol || pavucontrol"; # v4 middleClickCommand
        };

        brightness.show_label = true; # see battery note

        clock = {
          format = "{:%H:%M %a, %b %d}"; # v4 formatHorizontal
          vertical_format = "{:%H %M - %d %m}"; # v4 formatVertical
          tooltip_format = "{:%H:%M %a, %b %d}"; # v4 tooltipFormat
          font_family = "DepartureMono Nerd Font"; # v4 fontFixed (v5: per-widget only)
        };
      };

      plugins = {
        enabled = ["ycf/mawaqit" "pozzoo/hassio"];
        auto_update = false;
      };

      # v4 plugin settings (from ~/.config/noctalia/plugins/mawaqit/settings.json).
      # Select-type values are strings in v5: method "2" = ISNA, school "0" = Shafi.
      plugin_settings."ycf/mawaqit" = {
        city = "Calgary";
        country = "CA";
        method = "2";
        school = "0";
        hijriDayOffset = "0";
        twelveHourFormat = false;
        showNotifications = true;
        playAzan = false;
        azanFile = "azan1.mp3";
        tune = false;
      };

      # pozzoo/hassio: deliberately NOT configured here. There was no v4
      # settings.json to port, and ha_token would be world-readable in the
      # Nix store. Set ha_url + ha_token + shortcut entities once via
      # Settings -> Plugins (persists to the state settings.toml).

      # v4 desktopWidgets (eDP-1 had Clock + Weather). cx/cy are the widget
      # CENTER in logical px (v4 x/y was the top-left origin), so these are
      # approximations -- nudge once in edit mode (`noctalia msg desktop-widgets-edit`);
      # the editor persists to the state file. Binary clock style: not in v5.
      desktop_widgets = {
        enabled = true;
        widget_order = ["clock_main" "weather_main"];

        widget.clock_main = {
          type = "clock";
          output = "eDP-1";
          cx = 1930.0; # ~ v4 x=1680,y=1060 + half rendered size
          cy = 1390.0;
          settings = {
            format = "{:%H:%M}\n{:%e %B %Y}"; # v4 "HH:mm\nd MMMM yyyy"
            color = "primary"; # v4 usePrimaryColor
            background = false; # v4 showBackground
          };
        };

        widget.weather_main = {
          type = "weather";
          output = "eDP-1";
          cx = 120.0; # ~ v4 x=20,y=60
          cy = 90.0;
          settings.background = false;
        };
      };

      # v4's big lockscreen clock (clockStyle custom, "hh\nmm"; 12h there while
      # the bar stayed 24h). Default lock screen is still enabled underneath.
      lockscreen_widgets = {
        enabled = true;
        widget_order = ["big_clock"];

        widget.big_clock = {
          type = "clock";
          output = "eDP-1";
          cx = 960.0; # approx (center-ish, upper third) -- nudge in edit mode
          cy = 270.0;
          settings = {
            format = "{:%I}\n{:%M}"; # v4 "hh\nmm"
            color = "primary";
            background = false;
          };
        };
      };
    };
  };

  # Palette moved to the v5 layout (~/.config/noctalia/palettes/<Name>.json,
  # flat -- no per-name directory). The JSON shape is unchanged from v4.
  programs.noctalia.customPalettes.Pierre = ../../../cfg/noctalia/palettes/Pierre.json;

  # v4 runtime leftovers kept untouched in ~/.config/noctalia: settings.json,
  # colors.json(.bak), plugins.json(.bak), plugins/ (QML), colorschemes/.
  # Shell v5 ignores them; safe to `rm` manually once happy with v5.
}
