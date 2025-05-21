use std "path add"

path add "/run/current-system/sw/bin"
path add "~/bin"
path add "~/.local/bin"
path add "/opt/homebrew/bin"
path add "/opt/homebrew/sbin"
path add "~/.spicetify"
path add "~/.dotnet/tools"
path add "~/.orbstack/bin"

source ~/.config/nushell/atuin.nu
source ~/.config/nushell/zoxide.nu
source ~/.config/nushell/starship.nu
source ~/.config/nushell/mise.nu
source ~/.config/nushell/direnv.nu

alias rebuild = darwin-rebuild switch --flake ~/.config/nix-darwin
alias rebuild-upgrade = darwin-rebuild switch --flake ~/.config/nix-darwin --upgrade
alias rebuild-custom = darwin-rebuild switch --flake ~/.config/nix-darwin -I darwin=~/dev/nix-darwin
alias pip = python3 -m pip
alias g = git
alias gc = git commit -m
alias gp = git push
alias gl = git pull
alias gco = git checkout
alias l = ls -la
alias ghostty = /Applications/Ghostty.app/Contents/MacOS/ghostty
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

fastfetch