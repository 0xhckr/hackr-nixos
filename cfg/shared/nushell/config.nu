use std "path add"

let isDarwin = (uname | get kernel-name) == "Darwin"
let isLinux = (uname | get kernel-name) == "Linux"

# common paths
path add "/run/current-system/sw/bin"
path add "~/bin"
path add "~/.local/bin"
path add "~/.nix-profile/bin"

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

def rebuild [] {
  if $isLinux {
    sudo nixos-rebuild switch --flake ~/nixos#(hostname)
  } else {
    sudo darwin-rebuild switch --flake ~/nixos#(hostname)
  }
}

def restart-waybar [] {
  if $isLinux {
    if (ps | where name =~ "waybar" | length) > 0 {
      killall -q .waybar-wrapped
    }
    bash -c $"waybar & disown; exit"
    sleep 100ms
    cl
  } else {
    echo "waybar?? on macOS???"
  }
}

def nr [
  name: string, 
  ...rest: string
] {
  if $name == "list" {
    nix flake show --json --all-systems | from json | get apps | get (nix eval --impure --expr 'builtins.currentSystem' --raw) | transpose | get column0
  } else {
    let flake_ref = [".#", $name] | str join ""
    ^nix run $flake_ref ...$rest
  }
}

def code [...args: string] {
  if $args == null or $args == [] {
    bash -c $"nohup ~/.nix-profile/bin/cursor >/dev/null 2>&1 &"
  } else {
    bash -c $"nohup ~/.nix-profile/bin/cursor ($args | str join ' ') >/dev/null 2>&1 &"
  }
}

if $isLinux {
  ~/.config/nushell/aacpi.sh #produces files inside of ~/.nuget/plugins/ for azure artifacts credprovider
} else {
  "~/Library/Application Support/nushell/aacpi.sh"
}

fastfetch