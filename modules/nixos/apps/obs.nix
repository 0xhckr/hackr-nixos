{pkgs-stable, ...}: {
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs-stable.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
      obs-gstreamer
      obs-vkcapture
    ];
    package = pkgs-stable.obs-studio;
  };
  nixpkgs.config.allowUnsupportedSystem = true;
}
