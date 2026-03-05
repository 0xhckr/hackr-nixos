# NixOS Configuration — Agent Instructions

## Overview

This is a personal NixOS flake configuration for a single user (`hackr`, Mohammad Al-Ahdal) across three machines. All host configurations share a common module base and are composed via `flake.nix`.

- **Flake inputs** are pinned in `flake.lock`. Always keep `inputs.nixpkgs.follows = "nixpkgs"` when adding new inputs.
- **Special args** passed to every host: `inputs`, `system` (`x86_64-linux`), `username` (`hackr`), `fullName`, `email`.
- **Home Manager** is embedded as a NixOS module (not standalone). The single user's HM config is wired in via `modules/nixos/settings/users.nix` → `modules/home-manager/default.nix` → `modules/home-manager/links.nix`.

---

## Commands

| Purpose | Command |
|---|---|
| Apply config (preferred) | `nh os switch ~/nixos` |
| Apply config (fallback) | `sudo nixos-rebuild switch --flake .#<hostname>` |
| Test without activating | `nh os test ~/nixos` |
| Check flake syntax | `nix flake check` |
| Inspect flake outputs | `nix flake show` |
| Run a flake app | `nr <app-name>` (nushell alias) |
| Rebuild (nushell alias) | `rebuild` — also pushes to S3 cache on `infernape` |

Hosts: `infernape`, `torchic`, `snorlax`

---

## Directory Structure

```
flake.nix                        # Entry point; defines all inputs and nixosConfigurations
flake.lock                       # Pinned input revisions — commit after updates
hosts/
  infernape/                     # Primary desktop (state 24.11)
  torchic/                       # Laptop — includes torchic-audio.nix (state 25.05)
  snorlax/                       # Desktop with NVIDIA + OpenRazer (state 24.11)
    default.nix                  # Imports common modules + host-specific hardware
    boot.nix                     # Bootloader / kernel configuration
    hardware-configuration.nix   # Generated — do NOT hand-edit
modules/
  nixos/                         # System-level (runs as root / NixOS options)
    apps/                        # System-installed apps
      dev/                       # crush.nix, nushell (system-level)
      games/                     # steam, gamescope, prism, hytale, smm, gs.sh helper
      1password-browsers.nix
      libre-office.nix
      netbird.nix / tailscale.nix
      obs.nix / ollama.nix
    hardware/
      snorlax-nvidia.nix
      snorlax-openrazer.nix
      snorlax-power-management.nix
      torchic-audio.nix
    security/
      1password.nix              # polkit owner = username
      fingerprint.nix / pam.nix / polkit.nix
    settings/
      defaults.nix / firewall.nix / sound.nix / ssh.nix
      users.nix                  # Defines user, sets shell=nushell, imports HM
    styles/
      fonts.nix
      stylix.nix                 # Stylix enabled; base16 = rose-pine, cursor = BreezeX-RosePine-Linux
      themes/                    # rose-pine.yaml, poimandres.yaml, oscura-midnight.yaml
    system/
      gnome.nix / keyd.nix
      nh.nix                     # nh flake = ~/nixos, auto-clean keep 3d/3 gens
      niri.nix                   # Enables niri (niri-unstable flake input), xwayland-satellite
    virtualization/
      distrobox.nix / flatpak.nix
  home-manager/                  # User-level (runs as hackr / HM options)
    links.nix                    # Root HM file: imports all sub-modules, declares home.file symlinks & activations
    apps/
      general/default.nix        # JetBrains IDEs, Affinity v3, zen-browser (twilight), spicetify,
                                 # discord, obsidian, zoom, slack, GIMP, VLC, Yaak, etc.
      editor/                    # Zed (built from flake w/ FHS env), language servers, settings.json
      helix/                     # Helix (from helix flake master)
    dev/default.nix              # git, direnv, android-tools, nil, nixfmt, gcc, cargo, nodejs, bun, jdk, mc
    shell/
      atuin.nix / carapace.nix / starship.nix / zoxide.nix
      nushell.nix                # Main shell; defines rebuild, nr, code, zc, zic, pokefetch, copy-to-cache
    ssh/
      1password-agent.nix / config.nix / keys.nix
      git.nix                    # Drops ~/.gitconfig, ~/work/.gitconfig, ~/dev/.gitconfig
    terminal/
      ghostty.nix                # Ghostty config (DepartureMono Nerd Font, rose-pine theme, keybinds)
    ui/
      niri.nix                   # Writes ~/.config/niri/config-original.kdl (KDL, host-aware outputs)
      noctalia.nix               # Writes noctalia settings JSON (bar, widgets, wallpaper, etc.)
    work/
      azure.nix
cfg/                             # Static config files symlinked into ~/.config/ via links.nix
  atuin/ btop/ commie/ direnv/ fastfetch/
  niri/                          # delayed (startup script), laptop-outputs.kdl (torchic/snorlax)
  noctalia/                      # colors-original.json, plugins-original.json
  nushell/                       # direnv.nu, aacpi.sh
  vicinae/scripts/               # Scripts for vicinae launcher
  zed/                           # themes/, keymap.json
share/
  vicinae/themes/                # Vicinae theme files → ~/.local/share/vicinae/themes
ssh/                             # authorized_keys, home.gitconfig, work.gitconfig, dev.gitconfig
patches/                         # Ad-hoc nixpkgs patches
```

---

## Code Style

- **Indentation**: 2 spaces, no tabs.
- **Package references**: `pkgs.<name>` or `lib.getExe pkgs.<name>` for shell scripts.
- **String interpolation**: `${pkgs.foo}/bin/foo` — always interpolate store paths.
- **Overrides**: use `lib.mkForce` when overriding values inherited from other modules.
- **Module focus**: each `.nix` file should configure one concern. Group related files under a subdirectory with a `default.nix` that only contains `imports = [ ... ]`.
- **Static configs**: put non-Nix config files (KDL, JSON, shell scripts) in `cfg/` and symlink them via `links.nix` `home.file` entries with `force = true`.
- **Generated files** (`hardware-configuration.nix`): never edit by hand.
- **`allowUnfree`**: set in `links.nix` (`nixpkgs.config.allowUnfree = true`) — no need to repeat elsewhere.

---

## Key Patterns

### Adding a new NixOS module
1. Create `modules/nixos/<category>/<name>.nix`.
2. Add it to the relevant `modules/nixos/<category>/default.nix` imports list.
3. It will be picked up automatically by all hosts via `modules/nixos/default.nix`.

### Adding a host-specific NixOS module
Import it directly in `hosts/<hostname>/default.nix`:
```nix
imports = [
  ../../modules/nixos
  ../../modules/nixos/hardware/my-hardware.nix
  ./hardware-configuration.nix
  ./boot.nix
];
```

### Adding a new Home Manager module
1. Create `modules/home-manager/<category>/<name>.nix`.
2. Add it to the relevant `modules/home-manager/<category>/default.nix` imports list.
3. It is picked up via `links.nix` → category `default.nix`.

### Adding static config files
1. Drop the file in `cfg/<app>/`.
2. Add a `home.file` entry in `links.nix`:
```nix
".config/<app>" = {
  force = true;
  source = ../../cfg/<app>;
  recursive = true;
};
```

### Activation scripts (post-generation fixups)
Add to `home.activation` in `links.nix` or the relevant HM module:
```nix
home.activation.myFixup = lib.hm.dag.entryAfter ["linkGeneration"] ''
  #!/usr/bin/env bash
  cp -L ~/.config/app/template.json ~/.config/app/live.json
'';
```
This pattern is used for niri (`config-original.kdl` → `config.kdl`) and noctalia/zed settings so that the live files are mutable at runtime while the source remains managed by Nix.

### Theming
- Stylix drives the system-wide base16 theme (`rose-pine`). To opt a target out: `stylix.targets.<name>.enable = false;` (see `editor/default.nix` for Zed).
- Themes live in `modules/nixos/styles/themes/`. To switch themes, update the `base16Scheme` path in `modules/nixos/styles/stylix.nix`.

### Accessing flake inputs inside modules
All inputs are forwarded via `specialArgs`. Destructure in the function head:
```nix
{ inputs, system, pkgs, ... }: {
  environment.systemPackages = [ inputs.some-flake.packages.${system}.default ];
}
```

### Host-conditional logic (inside HM modules)
The `hostname` special arg is derived from `config.networking.hostName` and passed through HM's `extraSpecialArgs`:
```nix
{ hostname, ... }:
  lib.optionalString (hostname == "torchic" || hostname == "snorlax") "...";
```
See `modules/home-manager/ui/niri.nix` for a real example (laptop output block).

---

## Flake Inputs of Note

| Input | Purpose |
|---|---|
| `nixpkgs` | `nixos-unstable` — primary package set |
| `nixpkgs-stable` | `nixos-25.11` — available for stable pin-outs |
| `home-manager` | Follows nixpkgs |
| `stylix` | System-wide theming via base16 |
| `niri-unstable` | WIP niri branch (used as the actual niri package) |
| `niri-blurry` | Blur fork of niri (available but not currently selected) |
| `helix` | Helix editor from `master` |
| `zed` | Zed editor from source |
| `ghostty` | Ghostty terminal from `main` |
| `zen-browser` | Zen Browser (twilight channel) |
| `noctalia` | Noctalia shell/bar |
| `vicinae` | Vicinae app launcher |
| `commie` | commie app |
| `awww` | Wallpaper daemon (`awww-daemon`) |
| `spicetify` | Spotify theming |
| `affinity-nix` | Affinity suite on Linux |
| `_1password` | 1Password shell plugins |
| `nh` | `nh` NixOS helper |
| `nix-vscode-extensions` | VS Code extension set |
| `hytale` | Hytale launcher |
| `graphite` | Graphite editor |

---

## Nushell Aliases & Functions (defined in `modules/home-manager/shell/nushell.nix`)

| Name | Description |
|---|---|
| `rebuild` | `nh os switch ~/nixos`; on `infernape` also signs + pushes to S3 cache |
| `nr <name>` | Run a flake app (`nix run .#<name>`); `nr list` lists available apps |
| `code [path]` | Open Zed (nohup, detached) |
| `zc [path]` | `zoxide` jump + open Zed |
| `zic [path]` | `zoxide` interactive jump + open Zed |
| `pokefetch` | Fastfetch with a pokémon sprite (hostname as pokémon name) |
| `copy-to-cache` | Sign + push current system to S3 nix cache (infernape only) |
| `point-and-kill` | Pick a niri window and `kill -9` its PID |
| `cl` | Clear screen + run `pokefetch` (if not in tmux) |
| `g` / `gc` / `gp` / `gl` / `gco` | Git shortcuts |
| `b` | `bun` |
| `c` | `code` |

---

## Machines

### `infernape`
- **Hardware**: Desktop PC
- Primary workstation (`stateVersion = "24.11"`)
- Imports base `modules/nixos` only (no extra hardware modules)
- On successful rebuild, pushes the current system closure to the team S3 Nix binary cache

### `torchic`
- **Hardware**: Framework Laptop
- (`stateVersion = "25.05"`)
- Extra import: `modules/nixos/hardware/torchic-audio.nix` (Framework-specific audio quirks)
- Niri config includes laptop output block from `cfg/niri/laptop-outputs.kdl`

### `snorlax`
- **Hardware**: Razer Blade 17
- (`stateVersion = "24.11"`)
- Extra imports: `snorlax-nvidia.nix`, `snorlax-openrazer.nix`, `snorlax-power-management.nix`
- User added to `openrazer` group (Razer peripheral support)
- Niri config includes laptop output block (same KDL as torchic)