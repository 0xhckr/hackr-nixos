{
  inputs,
  lib,
  system,
  username,
  ...
}: {
  imports = [inputs.noctalia.homeModules.default];

  # The stylix noctalia-shell target writes a STATIC pierre-dark palette into
  # ~/.config/noctalia/colors.json (read-only). That overrides noctalia's own
  # runtime palette, so its UI can never switch to light. Disable it and let
  # noctalia own colors.json from the Pierre predefinedScheme below. (The
  # opacity/font bits that target also set are already mkForce'd in settings.)
  stylix.targets.noctalia-shell.enable = false;

  programs.noctalia-shell = {
    enable = true;
    package = inputs.noctalia.packages.${system}.default;

    plugins = {
      sources = [
        {
          enabled = true;
          name = "Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = let
        official = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      in {
        polkit-agent = official;
        mawaqit = official;
        display-settings = official;
        hassio = official;
        model-usage = official;
      };
      version = 2;
    };

    # colors come from the stylix noctalia-shell target

    settings = {
      appLauncher = {
        autoPasteClipboard = false;
        clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
        clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
        clipboardWrapText = true;
        customLaunchPrefix = "";
        customLaunchPrefixEnabled = false;
        enableClipPreview = true;
        enableClipboardHistory = false;
        enableSettingsSearch = true;
        enableWindowsSearch = true;
        iconMode = "tabler";
        ignoreMouseInput = false;
        pinnedApps = [];
        position = "center";
        screenshotAnnotationTool = "";
        showCategories = true;
        showIconBackground = false;
        sortByMostUsed = true;
        terminalCommand = "xterm -e";
        useApp2Unit = false;
        viewMode = "list";
      };
      audio = {
        cavaFrameRate = 30;
        mprisBlacklist = [];
        preferredPlayer = "";
        visualizerType = "linear";
        volumeFeedback = false;
        volumeOverdrive = false;
        volumeStep = 5;
      };
      bar = {
        autoHideDelay = 500;
        autoShowDelay = 150;
        # mkForce: keep the bar look; the stylix target only drives colors
        backgroundOpacity = lib.mkForce 0;
        barType = "floating";
        capsuleColorKey = "none";
        capsuleOpacity = lib.mkForce 1;
        density = "comfortable";
        displayMode = "always_visible";
        floating = true;
        frameRadius = 12;
        frameThickness = 8;
        hideOnOverview = false;
        marginHorizontal = 5;
        marginVertical = 5;
        monitors = [];
        outerCorners = false;
        position = "top";
        screenOverrides = [];
        showCapsule = true;
        showOutline = false;
        useSeparateOpacity = false;
        widgets = {
          center = [
            {
              colorizeIcons = true;
              hideMode = "hidden";
              id = "ActiveWindow";
              maxWidth = 450;
              scrollingMode = "hover";
              showIcon = true;
              textColor = "none";
              useFixedWidth = false;
            }
          ];
          left = [
            {
              characterCount = 2;
              colorizeIcons = false;
              emptyColor = "secondary";
              enableScrollWheel = true;
              focusedColor = "primary";
              followFocusedScreen = false;
              groupedBorderOpacity = 1;
              hideUnoccupied = false;
              iconScale = 0.8;
              id = "Workspace";
              labelMode = "index";
              occupiedColor = "secondary";
              pillSize = 0.6;
              reverseScroll = false;
              showApplications = false;
              showBadge = true;
              showLabelsOnlyWhenOccupied = true;
              unfocusedIconsOpacity = 1;
            }
          ];
          right = [
            {id = "plugin:mawaqit";}
            {id = "plugin:display-settings";}
            {id = "plugin:hassio";}
            {id = "plugin:model-usage";}
            {
              blacklist = [];
              chevronColor = "none";
              colorizeIcons = false;
              drawerEnabled = true;
              hidePassive = false;
              id = "Tray";
              pinned = [];
            }
            {
              colorizeDistroLogo = false;
              colorizeSystemIcon = "none";
              customIconPath = "";
              enableColorization = false;
              icon = "noctalia";
              id = "ControlCenter";
              useDistroLogo = false;
            }
            {
              hideWhenZero = true;
              hideWhenZeroUnread = false;
              iconColor = "none";
              id = "NotificationHistory";
              showUnreadBadge = true;
              unreadBadgeColor = "primary";
            }
            {
              deviceNativePath = "__default__";
              displayMode = "onhover";
              hideIfIdle = false;
              hideIfNotDetected = true;
              id = "Battery";
              showNoctaliaPerformance = false;
              showPowerProfiles = false;
            }
            {
              displayMode = "onhover";
              iconColor = "none";
              id = "Volume";
              middleClickCommand = "pwvucontrol || pavucontrol";
              textColor = "none";
            }
            {
              displayMode = "onhover";
              iconColor = "none";
              id = "Brightness";
              textColor = "none";
            }
            {
              clockColor = "none";
              customFont = "";
              formatHorizontal = "HH:mm ddd, MMM dd";
              formatVertical = "HH mm - dd MM";
              id = "Clock";
              tooltipFormat = "HH:mm ddd, MMM dd";
              useCustomFont = false;
            }
          ];
        };
      };
      brightness = {
        brightnessStep = 5;
        enableDdcSupport = false;
        enforceMinimum = true;
      };
      calendar = {
        cards = [
          {
            enabled = true;
            id = "calendar-header-card";
          }
          {
            enabled = true;
            id = "calendar-month-card";
          }
          {
            enabled = true;
            id = "weather-card";
          }
        ];
      };
      colorSchemes = {
        # darkMode is the global Pierre dark<->light toggle. It is declarative
        # here (resets to dark on relogin); the live switch within a session is
        # driven via gsettings/dconf by syncGsettings + the darkModeChange hook.
        darkMode = true;
        generationMethod = "vibrant";
        manualSunrise = "06:30";
        manualSunset = "18:30";
        monitorForColors = "";
        # Use the bundled Pierre scheme (dark + light variants) shipped via
        # xdg.configFile below, instead of deriving colors from the wallpaper.
        predefinedScheme = "Pierre";
        schedulingMode = "off";
        # On toggle, push prefer-dark/prefer-light to
        # org.gnome.desktop.interface color-scheme so every app that follows the
        # freedesktop appearance portal (ghostty, zed, gtk/gnome) switches live.
        syncGsettings = true;
        useWallpaperColors = false;
      };
      controlCenter = {
        cards = [
          {
            enabled = true;
            id = "profile-card";
          }
          {
            enabled = true;
            id = "shortcuts-card";
          }
          {
            enabled = true;
            id = "audio-card";
          }
          {
            enabled = true;
            id = "weather-card";
          }
          {
            enabled = true;
            id = "media-sysmon-card";
          }
        ];
        diskPath = "/";
        position = "close_to_bar_button";
        shortcuts = {
          left = [
            {id = "Network";}
            {id = "Bluetooth";}
            {id = "WallpaperSelector";}
          ];
          right = [
            {id = "Notifications";}
            {id = "PowerProfile";}
            {id = "KeepAwake";}
            {id = "NightLight";}
            {id = "DarkMode";}
          ];
        };
      };
      desktopWidgets = {
        enabled = true;
        gridSnap = true;
        monitorWidgets = [
          {
            name = "eDP-1";
            widgets = [
              {
                clockStyle = "binary";
                customFont = "";
                format = "HH:mm\nd MMMM yyyy";
                id = "Clock";
                roundedCorners = true;
                scale = 1.9392735076761305;
                showBackground = false;
                useCustomFont = false;
                usePrimaryColor = true;
                x = 1680;
                y = 1060;
              }
              {
                id = "Weather";
                scale = 1;
                showBackground = false;
                x = 20;
                y = 60;
              }
            ];
          }
        ];
      };
      dock = {
        animationSpeed = 1;
        backgroundOpacity = lib.mkForce 1;
        colorizeIcons = false;
        deadOpacity = 0.6;
        displayMode = "always_visible";
        enabled = false;
        floatingRatio = 1;
        inactiveIndicators = false;
        monitors = [];
        onlySameOutput = true;
        pinnedApps = [];
        pinnedStatic = false;
        position = "bottom";
        size = 1;
      };
      general = {
        allowPanelsOnScreenWithoutBar = true;
        allowPasswordWithFprintd = false;
        animationDisabled = false;
        animationSpeed = 1;
        autoStartAuth = false;
        avatarImage = "/home/${username}/.face";
        boxRadiusRatio = 1;
        clockFormat = "hh\\nmm";
        clockStyle = "custom";
        compactLockScreen = false;
        dimmerOpacity = 0.2;
        enableLockScreenCountdown = true;
        enableShadows = true;
        forceBlackScreenCorners = false;
        iRadiusRatio = 1;
        language = "";
        lockOnSuspend = false;
        lockScreenAnimations = false;
        lockScreenCountdownDuration = 10000;
        radiusRatio = 1;
        scaleRatio = 1;
        screenRadiusRatio = 1;
        shadowDirection = "bottom_right";
        shadowOffsetX = 2;
        shadowOffsetY = 3;
        showChangelogOnStartup = true;
        showHibernateOnLockScreen = false;
        showScreenCorners = false;
        showSessionButtonsOnLockScreen = true;
        telemetryEnabled = false;
      };
      hooks = {
        # Durable cross-app switch: noctalia substitutes $1 with "true"/"false"
        # (dark/light) then runs this via `sh -lc`. Writing color-scheme +
        # gtk-theme to dconf (writable) keeps the choice applied for the whole
        # session even though settings.json itself is a read-only Nix symlink.
        darkModeChange = ''
          if [ "$1" = "true" ]; then
            gsettings set org.gnome.desktop.interface color-scheme prefer-dark
            gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3-dark
            vicinae theme set pierre-dark || true
          else
            gsettings set org.gnome.desktop.interface color-scheme prefer-light
            gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3
            vicinae theme set pierre-light || true
          fi
        '';
        enabled = true;
        performanceModeDisabled = "";
        performanceModeEnabled = "";
        screenLock = "";
        screenUnlock = "";
        session = "";
        startup = "";
        wallpaperChange = "";
      };
      location = {
        analogClockInCalendar = false;
        firstDayOfWeek = -1;
        hideWeatherCityName = false;
        hideWeatherTimezone = false;
        name = "Calgary, AB";
        showCalendarEvents = true;
        showCalendarWeather = true;
        showWeekNumberInCalendar = false;
        use12hourFormat = false;
        useFahrenheit = false;
        weatherEnabled = true;
        weatherShowEffects = true;
      };
      network = {
        bluetoothDetailsViewMode = "grid";
        bluetoothHideUnnamedDevices = false;
        bluetoothRssiPollIntervalMs = 10000;
        bluetoothRssiPollingEnabled = false;
        wifiDetailsViewMode = "grid";
        wifiEnabled = true;
      };
      nightLight = {
        autoSchedule = true;
        dayTemp = "6500";
        enabled = true;
        forced = false;
        manualSunrise = "06:30";
        manualSunset = "18:30";
        nightTemp = "2500";
      };
      notifications = {
        backgroundOpacity = lib.mkForce 1;
        criticalUrgencyDuration = 15;
        enableBatteryToast = true;
        enableKeyboardLayoutToast = true;
        enableMediaToast = false;
        enabled = true;
        location = "top_right";
        lowUrgencyDuration = 3;
        monitors = [];
        normalUrgencyDuration = 8;
        overlayLayer = true;
        respectExpireTimeout = false;
        saveToHistory = {
          critical = true;
          low = true;
          normal = true;
        };
        sounds = {
          criticalSoundFile = "";
          enabled = false;
          excludedApps = "discord,firefox,chrome,chromium,edge";
          lowSoundFile = "";
          normalSoundFile = "";
          separateSounds = false;
          volume = 0.5;
        };
      };
      osd = {
        autoHideMs = 2000;
        backgroundOpacity = lib.mkForce 1;
        enabled = true;
        enabledTypes = [0 1 2];
        location = "top_right";
        monitors = [];
        overlayLayer = true;
      };
      plugins = {
        autoUpdate = false;
      };
      sessionMenu = {
        countdownDuration = 10000;
        enableCountdown = true;
        largeButtonsLayout = "grid";
        largeButtonsStyle = false;
        position = "center";
        powerOptions = [
          {
            action = "lock";
            enabled = true;
          }
          {
            action = "suspend";
            enabled = true;
          }
          {
            action = "hibernate";
            enabled = true;
          }
          {
            action = "reboot";
            enabled = true;
          }
          {
            action = "logout";
            enabled = true;
          }
          {
            action = "shutdown";
            enabled = true;
          }
        ];
        showHeader = true;
        showNumberLabels = true;
      };
      settingsVersion = 49;
      systemMonitor = {
        batteryCriticalThreshold = 5;
        batteryWarningThreshold = 20;
        cpuCriticalThreshold = 90;
        cpuPollingInterval = 1000;
        cpuWarningThreshold = 80;
        criticalColor = "";
        diskAvailCriticalThreshold = 10;
        diskAvailWarningThreshold = 20;
        diskCriticalThreshold = 90;
        diskPollingInterval = 30000;
        diskWarningThreshold = 80;
        enableDgpuMonitoring = false;
        externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
        gpuCriticalThreshold = 90;
        gpuPollingInterval = 3000;
        gpuWarningThreshold = 80;
        loadAvgPollingInterval = 3000;
        memCriticalThreshold = 90;
        memPollingInterval = 1000;
        memWarningThreshold = 80;
        networkPollingInterval = 1000;
        swapCriticalThreshold = 90;
        swapWarningThreshold = 80;
        tempCriticalThreshold = 90;
        tempWarningThreshold = 80;
        useCustomColors = false;
        warningColor = "";
      };
      templates = {
        activeTemplates = [];
        enableUserTheming = false;
      };
      ui = {
        bluetoothDetailsViewMode = "grid";
        bluetoothHideUnnamedDevices = false;
        boxBorderEnabled = false;
        # mkForce: keep current fonts/opacity; stylix has no fonts configured
        # and would fall back to DejaVu
        fontDefault = lib.mkForce "DM Sans";
        fontDefaultScale = 1;
        fontFixed = lib.mkForce "DepartureMono Nerd Font";
        fontFixedScale = 1;
        networkPanelView = "wifi";
        panelBackgroundOpacity = lib.mkForce 0.93;
        panelsAttachedToBar = true;
        settingsPanelMode = "centered";
        tooltipsEnabled = true;
        wifiDetailsViewMode = "grid";
      };
      wallpaper = {
        automationEnabled = false;
        directory = "/home/${username}/walls";
        enableMultiMonitorDirectories = false;
        enabled = true;
        fillColor = "#000000";
        fillMode = "crop";
        hideWallpaperFilenames = false;
        monitorDirectories = [];
        overviewEnabled = false;
        panelPosition = "follow_bar";
        randomIntervalSec = 300;
        setWallpaperOnAllMonitors = true;
        showHiddenFiles = false;
        solidColor = "#1a1a2e";
        sortOrder = "name";
        transitionDuration = 1500;
        transitionEdgeSmoothness = 0.05;
        transitionType = "random";
        useSolidColor = false;
        useWallhaven = false;
        viewMode = "single";
        wallhavenApiKey = "";
        wallhavenCategories = "111";
        wallhavenOrder = "desc";
        wallhavenPurity = "100";
        wallhavenQuery = "";
        wallhavenRatios = "";
        wallhavenResolutionHeight = "";
        wallhavenResolutionMode = "atleast";
        wallhavenResolutionWidth = "";
        wallhavenSorting = "relevance";
        wallpaperChangeMode = "random";
      };
    };
  };

  # The old activation script left plain (read-only) copies of these files
  # behind; force HM to replace them with managed symlinks.
  xdg.configFile = {
    "noctalia/settings.json".force = true;
    "noctalia/plugins.json".force = true;
    # NOTE: colors.json is intentionally NOT managed here. Noctalia writes its
    # live palette there on every theme/dark-mode change; a Nix symlink would be
    # read-only and freeze the shell on dark. See the activation below.

    # Pierre predefined color scheme (dark + light). Noctalia searches
    # ~/.config/noctalia/colorschemes for user schemes and only reads this
    # file, so a read-only Nix symlink is fine.
    "noctalia/colorschemes/Pierre/Pierre.json" = {
      force = true;
      source = ../../../cfg/noctalia/colorschemes/Pierre/Pierre.json;
    };
  };

  # Noctalia needs writable runtime config. A read-only Nix symlink makes the
  # dark-mode toggle fail to persist: noctalia flips darkMode, the save to
  # settings.json is rejected, the FileView re-reads the unchanged file and
  # snaps straight back to dark. So replace the settings.json symlink with a
  # writable copy (declarative values still reapply from the store on every
  # rebuild) and drop colors.json so noctalia regenerates a writable one.
  home.activation.noctaliaWritableConfig =
    lib.hm.dag.entryAfter ["linkGeneration"] ''
      cfg="''${XDG_CONFIG_HOME:-$HOME/.config}/noctalia"
      if [ -L "$cfg/settings.json" ]; then
        src="$(readlink -f "$cfg/settings.json")"
        rm -f "$cfg/settings.json"
        install -m644 "$src" "$cfg/settings.json"
      fi
      [ -L "$cfg/colors.json" ] && rm -f "$cfg/colors.json"
      true
    '';
}
