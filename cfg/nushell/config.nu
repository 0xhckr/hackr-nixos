use std "path add"

path add "/run/current-system/sw/bin"
path add "/run/wrappers/bin"
path add "~/bin"
path add "~/.local/bin"

source ./atuin.nu
source ./zoxide.nu
source ./starship.nu
source ./mise.nu
source ./direnv.nu

alias rebuild = sudo nixos-rebuild switch --flake ~/nixos#(hostname)
alias rebuild-upgrade = sudo nixos-rebuild switch --flake ~/nixos#(hostname) --upgrade
alias pip = python3 -m pip
alias g = git
alias gc = git commit -m
alias gp = git push
alias gl = git pull
alias gco = git checkout
alias l = ls -la
alias b = bun
alias m = mise

def cl [] {
  clear
  fastfetch
}

def code [...args: string] {
  if $args == null or $args == [] {
    bash -c $"nohup ~/.nix-profile/bin/cursor >/dev/null 2>&1 &"
  } else {
    bash -c $"nohup ~/.nix-profile/bin/cursor ($args | str join ' ') >/dev/null 2>&1 &"
  }
}

~/.config/nushell/aacpi.sh #produces files inside of ~/.nuget/plugins/ for azure artifacts credprovider

fastfetch