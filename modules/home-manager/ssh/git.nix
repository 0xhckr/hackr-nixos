{...}: {
  home.file = {
    "work/.gitconfig" = {
      source = ../../../ssh/work.gitconfig;
      force = true;
    };
    "dev/.gitconfig" = {
      source = ../../../ssh/dev.gitconfig;
      force = true;
    };
    ".gitconfig" = {
      source = ../../../ssh/home.gitconfig;
      force = true;
    };
  };
}
