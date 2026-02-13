{...}: {
  home.file = {
    ".ssh/id_rsa_work.pub" = {
      source = ../../../ssh/id_rsa_work.pub;
      force = true;
    };
    ".ssh/id_rsa_personal.pub" = {
      source = ../../../ssh/id_rsa_personal.pub;
      force = true;
    };
  };
}
