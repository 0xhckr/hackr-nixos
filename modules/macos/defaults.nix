{ ... }:
{
  system.defaults = {
    ".GlobalPreferences" = {
      "com.apple.mouse.scaling" = 0.5;
      # "com.apple.mouse.linear" = true; # does not work yet
    };
    NSGlobalDomain = {
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
    };

    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      CreateDesktop = false;
    };
    dock = {
      show-recents = false;
      static-only = true;
      autohide = true;
    };
    WindowManager.StandardHideDesktopIcons = true;
  };
}
