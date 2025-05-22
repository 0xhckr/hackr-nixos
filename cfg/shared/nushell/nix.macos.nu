let isLinux = (uname | get kernel-name) == "Linux"
if $isLinux {
  return
}

alias rebuild = sudo darwin-rebuild switch --flake ~/nixos#(hostname)
