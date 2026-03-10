{...}: {
  home.file = {
    ".gitconfig" = {
      source = ../../../ssh/home.gitconfig;
      force = true;
    };
  };
}
