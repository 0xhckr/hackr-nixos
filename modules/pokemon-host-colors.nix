hostname:
let
  fire = "#F08030";
  hosts = {
    flareon = {
      primary = fire;
      secondary = fire;
    };
    infernape = {
      primary = fire;
      secondary = "#C03028";
      accentText = "#ffffff";
    };
    mareep = {
      primary = "#F8D030";
      secondary = "#F8D030";
    };
    metagross = {
      primary = "#B8B8D0";
      secondary = "#F85888";
    };
    snorlax = {
      primary = "#A8A878";
      secondary = "#A8A878";
    };
  };
  colors =
    hosts.${hostname} or {
      primary = "#171922";
      secondary = "#171922";
      text = "#ffffff";
      accentText = "#ffffff";
    };
in
colors
// {
  text = colors.text or "#1b1e28";
  accentText = colors.accentText or "#1b1e28";
}
