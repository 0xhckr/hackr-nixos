# Git config. Signing goes through 1Password's op-ssh-sign on macOS (the GUI
# app is always local here, so no forwarded-session helper is needed).
{...}: {
  home.file = {
    ".gitconfig" = {
      source = ../../../ssh/darwin.gitconfig;
      force = true;
    };

    # Global git ignore (also honored by jj) — see cfg/git/ignore.
    ".config/git/ignore" = {
      source = ../../../cfg/git/ignore;
      force = true;
    };
  };
}
