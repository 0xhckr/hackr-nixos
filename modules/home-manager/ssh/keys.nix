{...}: {
  home.file = {
    ".ssh/id_rsa.pub" = {
      source = ../../../ssh/id_rsa.pub;
      force = true;
    };
  };
}
