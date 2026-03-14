{...}: {
  home.file = {
    ".gitconfig" = {
      source = ../../../ssh/home.gitconfig;
      force = true;
    };
    ".config/jj/config.toml" = {
      source = ../../../ssh/home.jj-config.toml;
      force = true;
    };
  };
}
