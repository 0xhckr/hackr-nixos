#!/usr/bin/env bash
set -euo pipefail

# Install nushell + shell integrations (carapace, atuin, starship, zoxide, direnv)
# Designed for Ubuntu hosts

echo "=> Updating apt and installing prerequisites..."
sudo apt update && sudo apt install -y curl git unzip

get_latest_version() {
  curl -sL "https://api.github.com/repos/$1/releases/latest" \
    | grep '"tag_name"' \
    | head -1 \
    | sed -E 's/.*"([^"]+)".*/\1/'
}

ARCH=$(uname -m)

# --- nushell ---
if ! command -v nu &>/dev/null; then
  echo "=> Installing nushell..."
  case "$ARCH" in
    x86_64) NU_ARCH="x86_64" ;;
    aarch64) NU_ARCH="aarch64" ;;
    *) echo "Unsupported arch: $ARCH"; exit 1 ;;
  esac
  NU_TAG=$(get_latest_version "nushell/nushell")
  NU_VERSION=${NU_TAG#v}
  NU_URL="https://github.com/nushell/nushell/releases/download/${NU_TAG}/nu-${NU_VERSION}-${NU_ARCH}-unknown-linux-gnu.tar.gz"
  TMPDIR=$(mktemp -d)
  echo "   Downloading nushell ${NU_VERSION}..."
  curl -sL "$NU_URL" | tar xz -C "$TMPDIR"
  sudo cp "${TMPDIR}/nu-${NU_VERSION}-${NU_ARCH}-unknown-linux-gnu/nu" /usr/local/bin/
  sudo cp "${TMPDIR}/nu-${NU_VERSION}-${NU_ARCH}-unknown-linux-gnu/plugin_"* /usr/local/bin/ 2>/dev/null || true
  rm -rf "$TMPDIR"
  echo "   Installed nushell $(nu --version)"
else
  echo "=> nushell already installed ($(nu --version))"
fi

# --- carapace ---
if ! command -v carapace &>/dev/null; then
  echo "=> Installing carapace..."
  case "$ARCH" in
    x86_64) CAP_ARCH="amd64" ;;
    aarch64) CAP_ARCH="arm64" ;;
  esac
  CAP_TAG=$(get_latest_version "carapace-sh/carapace-bin")
  CAP_VERSION=${CAP_TAG#v}
  CAP_URL="https://github.com/carapace-sh/carapace-bin/releases/download/${CAP_TAG}/carapace-bin_${CAP_VERSION}_linux_${CAP_ARCH}.tar.gz"
  TMPDIR=$(mktemp -d)
  echo "   Downloading carapace ${CAP_VERSION}..."
  curl -sL "$CAP_URL" | tar xz -C "$TMPDIR"
  sudo cp "${TMPDIR}/carapace" /usr/local/bin/
  rm -rf "$TMPDIR"
  echo "   Installed carapace ${CAP_VERSION}"
else
  echo "=> carapace already installed"
fi

# --- atuin ---
if ! command -v atuin &>/dev/null; then
  echo "=> Installing atuin..."
  curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh | sh
else
  echo "=> atuin already installed ($(atuin --version))"
fi

# --- starship ---
if ! command -v starship &>/dev/null; then
  echo "=> Installing starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
else
  echo "=> starship already installed ($(starship --version))"
fi

# --- zoxide ---
if ! command -v zoxide &>/dev/null; then
  echo "=> Installing zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
else
  echo "=> zoxide already installed"
fi

# --- direnv ---
if ! command -v direnv &>/dev/null; then
  echo "=> Installing direnv..."
  sudo apt install -y direnv
else
  echo "=> direnv already installed"
fi

# --- fastfetch (optional, for pokefetch) ---
if ! command -v fastfetch &>/dev/null; then
  echo "=> Installing fastfetch..."
  sudo apt install -y fastfetch 2>/dev/null || {
    case "$ARCH" in
      x86_64) FF_ARCH="amd64" ;;
      aarch64) FF_ARCH="aarch64" ;;
    esac
    FF_TAG=$(get_latest_version "fastfetch-cli/fastfetch")
    FF_VERSION=${FF_TAG#v}
    TMPDIR=$(mktemp -d)
    echo "   Downloading fastfetch ${FF_VERSION}..."
    curl -sL "https://github.com/fastfetch-cli/fastfetch/releases/download/${FF_TAG}/fastfetch-linux-${FF_ARCH}.deb" -o "${TMPDIR}/fastfetch.deb"
    sudo dpkg -i "${TMPDIR}/fastfetch.deb"
    rm -rf "$TMPDIR"
    echo "   Installed fastfetch ${FF_VERSION}"
  }
else
  echo "=> fastfetch already installed"
fi

# --- pokeget-rs (optional, for pokefetch) ---
if ! command -v pokeget &>/dev/null; then
  echo "=> Installing pokeget-rs..."
  case "$ARCH" in
    x86_64) PG_ARCH="x86_64" ;;
    aarch64) PG_ARCH="aarch64" ;;
  esac
  PG_TAG=$(get_latest_version "talwat/pokeget-rs")
  PG_VERSION=${PG_TAG#v}
  TMPDIR=$(mktemp -d)
  echo "   Downloading pokeget ${PG_VERSION}..."
  curl -sL "https://github.com/talwat/pokeget-rs/releases/download/${PG_TAG}/pokeget-Linux-${PG_ARCH}.tar.gz" | tar xz -C "$TMPDIR"
  sudo cp "${TMPDIR}/pokeget" /usr/local/bin/ 2>/dev/null || { echo "   Could not find pokeget binary in archive, skipping"; }
  rm -rf "$TMPDIR"
  echo "   Installed pokeget ${PG_VERSION}"
else
  echo "=> pokeget already installed"
fi

# --- nushell config ---
echo "=> Setting up nushell config..."

read -r -p "   Reset all config files to defaults? [y/N] " RESET </dev/tty
RESET=${RESET:-N}

CONFIG_FILES=(
  ~/.config/nushell/env.nu
  ~/.config/nushell/config.nu
  ~/.config/nushell/direnv.nu
  ~/.config/nushell/vendor/zoxide.nu
  ~/.config/atuin/config.toml
  ~/.config/fastfetch/config.jsonc
  ~/.config/starship.toml
  ~/.cache/carapace/init.nu
  ~/.local/share/atuin/init.nu
)

if [[ "${RESET,,}" == "y" ]]; then
  echo "   Removing existing config files..."
  for f in "${CONFIG_FILES[@]}"; do
    rm -f "$f"
  done
fi

mkdir -p ~/.config/nushell ~/.config/nushell/vendor ~/.config/atuin ~/.cache/carapace ~/.local/share/atuin

tee ~/.config/nushell/direnv.nu > /dev/null << 'DIRENV_EOF'
$env.config = {
  hooks: {
    pre_prompt: [{ ||
      if (which direnv | is-empty) {
        return
      }

      direnv export json | from json | default {} | load-env
      if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
        $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
      }
    }]
  }
}
DIRENV_EOF

zoxide init nushell > ~/.config/nushell/vendor/zoxide.nu

tee ~/.config/nushell/config.nu > /dev/null << 'NU_CONFIG_EOF'
use std "path add"

$env.config.show_banner = false

path add "~/bin"
path add "~/.local/bin"
path add "~/.atuin/bin"

source ./direnv.nu

# carapace completions
source ~/.cache/carapace/init.nu

# atuin
source ~/.local/share/atuin/init.nu

# starship prompt
$env.STARSHIP_SHELL = "nu"
$env.PROMPT_COMMAND = { || starship prompt --cmd-duration $env.CMD_DURATION_MS }
$env.PROMPT_COMMAND_RIGHT = ""
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""

# zoxide
source ./vendor/zoxide.nu


def cl [] {
  clear
  if $env.TMUX? == null {
    pokefetch
  }
}

def pokefetch [] {
  let FETCHER_CMD = "fastfetch --logo none"
  let EXTRA_PADDING_H = 2
  let EXTRA_PADDING_W = 2
  let WIDTH = 38

  let pokemon_name = (hostname)

  let sprite = (pokeget $pokemon_name --hide-name | complete | get stdout)
  let fetcher_height = (bash -c $FETCHER_CMD | lines | length)
  let sprite_height = ($sprite | lines | length)

  let pad_top = (($fetcher_height - $sprite_height) / 2 + $EXTRA_PADDING_H)
  let pad_top = (if $pad_top < 0 { 0 } else { $pad_top })

  let sprite_width = ($sprite | lines | each { |line|
    $line | ansi strip | split chars | length
  } | math max)

  let pad_horizontal = (($WIDTH - $sprite_width) / 2 + $EXTRA_PADDING_W)
  let pad_horizontal = (if $pad_horizontal < 0 { 0 } else { $pad_horizontal })
  let pad_horizontal = ($pad_horizontal | math floor)
  let pad_top = ($pad_top | math floor)

  $sprite | fastfetch --file-raw - --logo-padding $pad_horizontal --logo-padding-top $pad_top
}

def ghosttify [user: string, host: string] {
  let command = ["infocmp -x xterm-ghostty | ssh ", $user, "@", $host, " -- tic -x -"]
  bash -c ($command | str join)
}

def --env --wrapped zc [...args: string] {
  if $args == null or $args == [] {
    cd ~
  } else {
    __zoxide_z ...$args
  }
}

def --env --wrapped zic [...args: string] {
  if $args == null or $args == [] {
    __zoxide_zi
  } else {
    __zoxide_zi ...$args
  }
}

if $env.TERM? == "xterm-ghostty" {
  pokefetch
}
NU_CONFIG_EOF

tee ~/.config/nushell/env.nu > /dev/null << 'NU_ENV_EOF'
# env.nu - environment variables loaded before config.nu
$env.ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
    to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
  }
}
NU_ENV_EOF

# --- fastfetch config ---
mkdir -p ~/.config/fastfetch
tee ~/.config/fastfetch/config.jsonc > /dev/null << 'FASTFETCH_EOF'
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "display": {
      "separator": " "
  },
  "modules": [
  {
    "key": "\n",
    "type": "custom"
  },
      {
          "key": "{#39}╭───────────╮",
          "type": "custom"
      },
      {
          "key": "{#39}│ {#31} user    {#39}│",
          "type": "title",
          "format": "{1}"
      },
      {
          "key": "{#39}│ {#32}󰇅 host    {#39}│",
          "type": "title",
          "format": "{2}"
      },
      {
          "key": "{#39}│ {#34}󰟾 distro  {#39}│",
          "type": "os",
    "format": "{3}"
      },
      {
          "key": "{#39}│ {#35} kernel  {#39}│",
          "type": "kernel",
    "format": "{1} {2}"
      },
      {
          "key": "{#39}│ {#33}󰅐 uptime  {#39}│",
          "type": "uptime",
    "format": "{2} Hrs {3} Mins"
      },
      {
          "key": "{#39}│ {#36}󰇄 desktop {#39}│",
          "type": "de"
      },
      {
          "key": "{#39}│ {#31} term    {#39}│",
          "type": "terminal",
    "format": "{5}"
      },
      {
          "key": "{#39}│ {#32} shell   {#39}│",
          "type": "shell",
    "format": "{6}"
      },
      {
          "key": "{#39}│ {#34}󰉉 disk    {#39}│",
          "type": "disk",
          "folders": "/",
    "format": "{1} / {2} ({3})"
      },
      {
          "key": "{#39}│ {#35} memory  {#39}│",
          "type": "memory",
    "format": "{1} / {2} ({3})"
      },
      {
          "key": "{#39}│ {#36}󰩟 network {#39}│",
          "type": "localip",
          "format": "{1}"
      },
      {
          "key": "{#39}├───────────┤",
          "type": "custom"
      },
      {
          "key": "{#39}│ {#39} colors  {#39}│ 󰮯 ",
          "type": "colors",
          "symbol": "circle"
      },
      {
          "key": "{#39}╰───────────╯",
          "type": "custom"
      }
  ]
}
FASTFETCH_EOF

# --- atuin config ---
tee ~/.config/atuin/config.toml > /dev/null << 'ATUIN_EOF'
search_mode = "fuzzy"
filter_mode = "host"
workspaces = true
style = "compact"
inline_height = 10
invert = false
show_preview = true
show_help = false
show_tabs = false
enter_accept = true

[stats]
common_subcommands = [
  "apt",
  "cargo",
  "composer",
  "dnf",
  "docker",
  "git",
  "go",
  "ip",
  "kubectl",
  "nix",
  "nmcli",
  "npm",
  "pecl",
  "pnpm",
  "podman",
  "port",
  "systemctl",
  "tmux",
  "yarn",
  "bun",
  "hx",
]
common_prefix = ["sudo"]
ignored_commands = ["cd", "ls", "l", "z"]

[sync]
records = true

[theme]
name = "oscura-midnight"
ATUIN_EOF

# --- starship config ---
tee ~/.config/starship.toml > /dev/null << 'STARSHIP_EOF'
format = "($nix_shell$container$git_metrics)$cmd_duration$hostname$localip$shlvl$shell$env_var$sudo$character\n"
palette = "poimandres"
right_format = "$singularity$kubernetes$directory$vcsh$fossil_branch$git_branch$git_commit$git_state$git_status$hg_branch$pijul_channel$docker_context$package$c$cpp$cmake$cobol$daml$dart$deno$dotnet$elixir$elm$erlang$fennel$fortran$golang$guix_shell$haskell$haxe$helm$java$julia$kotlin$gradle$lua$nim$nodejs$ocaml$opa$perl$php$pulumi$purescript$python$raku$rlang$red$ruby$rust$scala$solidity$swift$terraform$vlang$vagrant$xmake$zig$buf$conda$pixi$meson$spack$memory_usage$aws$gcloud$openstack$azure$crystal$custom$status$os$battery$time\n"

[c]
disabled = false
format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) "
style = "bg:overlay fg:pine"
symbol = " "

[directory]
format = "[](fg:overlayd)[ $path ]($style)[](fg:overlayd) "
style = "bg:overlayd fg:pine"
truncate_to_repo = false
truncation_length = 5
truncation_symbol = ""

[directory.substitutions]
Documents = "󰈙"
Downloads = " "
Music = " "
Pictures = " "
nixos = " "

[elixir]
disabled = false
format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) "
style = "bg:overlay fg:pine"
symbol = " "

[elm]
disabled = false
format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) "
style = "bg:overlay fg:pine"
symbol = " "

[fill]
style = "fg:overlay"
symbol = " "

[git_branch]
format = "[](fg:overlaydd)[ $symbol $branch ]($style)[](fg:overlaydd) "
style = "bg:overlaydd fg:foam"
symbol = ""

[git_status]
ahead = "[⇡(${count})](bg:overlaydd fg:foam)"
behind = "[⇣(${count})](bg:overlaydd fg:rose)"
deleted = "[✘($count)](style)"
disabled = false
diverged = "⇕[[](bg:overlaydd fg:iris)[⇡(${ahead_count})](bg:overlaydd fg:foam)[⇣(${behind_count})](bg:overlaydd fg:rose)[]](bg:overlaydd fg:iris)"
format = "[](fg:overlaydd)([$all_status$ahead_behind]($style))[](fg:overlaydd) "
modified = "[!($count)](bg:overlaydd fg:gold)"
renamed = "[»($count)](bg:overlaydd fg:iris)"
staged = "[++($count)](bg:overlaydd fg:gold)"
stashed = "[($count)](bg:overlaydd fg:gold)"
style = "bg:overlaydd fg:love"
untracked = "[?($count)](bg:overlaydd fg:gold)"
up_to_date = "[ ✓ ](bg:overlaydd fg:iris)"

[golang]
disabled = false
format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) "
style = "bg:overlay fg:pine"
symbol = " "

[haskell]
disabled = false
format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) "
style = "bg:overlay fg:pine"
symbol = " "

[hostname]
disabled = false
format = "[](fg:overlayd)[   $hostname ]($style)[](fg:overlayd) "
ssh_only = false
style = "bg:overlayd fg:iris"

[java]
disabled = false
format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) "
style = "bg:overlay fg:pine"
symbol = " "

[julia]
disabled = false
format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) "
style = "bg:overlay fg:pine"
symbol = " "

[nim]
disabled = false
format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) "
style = "bg:overlay fg:pine"
symbol = " "

[nodejs]
disabled = false
format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) "
style = "bg:overlay fg:pine"
symbol = " "

[palettes.base16]
base00 = "#191724"
base01 = "#1f1d2e"
base02 = "#26233a"
base03 = "#6e6a86"
base04 = "#908caa"
base05 = "#e0def4"
base06 = "#e0def4"
base07 = "#524f67"
base08 = "#eb6f92"
base09 = "#f6c177"
base0A = "#ebbcba"
base0B = "#31748f"
base0C = "#9ccfd8"
base0D = "#c4a7e7"
base0E = "#f6c177"
base0F = "#524f67"
base10 = "#191724"
base11 = "#191724"
base12 = "#eb6f92"
base13 = "#ebbcba"
base14 = "#31748f"
base15 = "#9ccfd8"
base16 = "#c4a7e7"
base17 = "#f6c177"
black = "#191724"
blue = "#c4a7e7"
bright-black = "#6e6a86"
bright-blue = "#c4a7e7"
bright-cyan = "#9ccfd8"
bright-green = "#31748f"
bright-magenta = "#f6c177"
bright-purple = "#f6c177"
bright-red = "#eb6f92"
bright-white = "#524f67"
bright-yellow = "#ebbcba"
brown = "#524f67"
cyan = "#9ccfd8"
green = "#31748f"
magenta = "#f6c177"
orange = "#f6c177"
purple = "#f6c177"
red = "#eb6f92"
white = "#e0def4"
yellow = "#ebbcba"

[palettes.oscura-midnight]
foam = "#54c0a3"
gold = "#f9b98c"
iris = "#e6e7a3"
love = "#d84f68"
overlay = "#232323"
overlayd = "#161616"
overlaydd = "#0b0b0f"
pine = "#4ebe96"
rose = "#e6e7a3"

[palettes.poimandres]
foam = "#54c0a3"
gold = "#add7ff"
iris = "#ffffff"
love = "#d0679d"
overlay = "#252b37"
overlayd = "#171922"
overlaydd = "#1b1e28"
pine = "#4ebe96"
rose = "#5de4c7"

[python]
disabled = false
format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) "
style = "bg:overlay fg:pine"
symbol = " "

[rust]
disabled = false
format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) "
style = "bg:overlay fg:pine"
symbol = " "

[scala]
disabled = false
format = "[](fg:overlay)[$symbol$version]($style)[](fg:overlay) "
style = "bg:overlay fg:pine"
symbol = " "

[time]
disabled = false
format = "[](fg:overlay)[ $time ]($style)[](fg:overlay)"
style = "bg:overlay fg:rose"
time_format = "%I:%M%P"
use_12hr = true

[username]
disabled = false
format = "[](fg:overlay)[ 󰧱 $user ]($style)[](fg:overlay) "
show_always = true
style_root = "bg:overlay fg:iris"
style_user = "bg:overlay fg:iris"
STARSHIP_EOF

# --- carapace init ---
echo "=> Initializing carapace..."
carapace _carapace nushell | sed 's|"/homeless-shelter|$"($env.HOME)|g' > ~/.cache/carapace/init.nu

# --- atuin init ---
echo "=> Initializing atuin..."
atuin init nu > ~/.local/share/atuin/init.nu

# --- disable motd ---
if [ -f ~/.hushlogin ]; then
  echo "=> motd already disabled"
else
  echo "=> Disabling motd..."
  touch ~/.hushlogin
fi

# --- set nushell as default shell ---
CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)
if [[ "$CURRENT_SHELL" != *"/nu"* ]]; then
  echo "=> Setting nushell as default shell..."
  NU_PATH=$(which nu)
  if ! grep -q "$NU_PATH" /etc/shells 2>/dev/null; then
    echo "$NU_PATH" | sudo tee -a /etc/shells
  fi
  sudo chsh -s "$NU_PATH" "$USER"
  echo "   Default shell changed to nushell (takes effect on next login)"
else
  echo "=> nushell is already the default shell"
fi

echo ""
echo "=> Done! Log out and back in (or run 'nu') to start using nushell."
