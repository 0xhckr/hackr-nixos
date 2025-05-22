let isMacOS = (uname | get kernel-name) == "Darwin"
if $isMacOS {
  return
}

alias rebuild = sudo nixos-rebuild switch --flake ~/nixos#(hostname)
