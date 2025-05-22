use std "path add"

let isDarwin = (uname | get kernel-name) == "Darwin"
let isLinux = (uname | get kernel-name) == "Linux"

# common paths
path add "/run/current-system/sw/bin"
path add "~/bin"
path add "~/.local/bin"

# nixos paths
if $isLinux {
  path add "/run/wrappers/bin"
}

# darwin paths
if $isDarwin {
  path add "/opt/homebrew/bin"
  path add "/opt/homebrew/sbin"
  path add "~/.spicetify"
  path add "~/.dotnet/tools"
  path add "~/.orbstack/bin"
}

source ./atuin.nu
source ./zoxide.linux.nu
source ./zoxide.macos.nu
source ./starship.nu
source ./mise.nu
source ./direnv.nu
source ./nix.linux.nu
source ./nix.macos.nu

alias pip = python3 -m pip
alias g = git
alias gc = git commit -m
alias gp = git push
alias gl = git pull
alias gco = git checkout
alias l = ls -la
alias b = bun

def cl [] {
  clear
  fastfetch
}

def nr [
  name: string, 
  ...rest: string
] {
  let flake_ref = [".#", $name] | str join ""
  ^nix run $flake_ref ...$rest
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