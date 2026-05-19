# NixOS Configuration

<img width="2880" height="1920" alt="image" src="https://github.com/user-attachments/assets/178cd0b7-213e-44a7-8863-edf453711c4f" />


This repository contains NixOS system and Home Manager configurations for multiple machines. It manages the entire system setup declaratively using Nix, including applications, services, and user preferences.

## Overview

This is a comprehensive NixOS configuration repository that includes:
- System-level configurations for multiple hosts
- User-level configurations via Home Manager
- Desktop environments and window managers
- Development tooling and applications
- Custom application configurations

## Features

- **Multiple Host Support**: Configurations for different machines
- **Modern Window Manager**: Niri Wayland compositor with custom theming
- **Development Environment**: Preconfigured development tools and IDEs
- **Consistent Theming**: Coordinated appearance across applications
- **Security**: Fingerprint support and other security enhancements
- **Declarative**: All configurations are version-controlled and reproducible

## Structure

- `hosts/` - Host-specific configurations (laptop, work machine, desktop)
- `modules/nixos/` - System-level modules (applications, system services, settings)
- `modules/home-manager/` - User-level modules (shell, editors, UI settings)
- `cfg/` - Static configuration files for various applications
- `ssh/` - SSH configurations and keys

## Prerequisites

- A NixOS installation
- Basic knowledge of the Nix language and flake system
- `home-manager` installed (for user configurations)

## Installation (really only useful for the owner)

1. Clone this repository to your NixOS system
2. Enter the repository directory: `cd path/to/repository`
3. Apply system configuration:
   ```bash
   sudo nixos-rebuild switch --flake .#<hostname>
   ```

## Available Host Configurations

The repository supports multiple hosts defined in the `hosts/` directory. The available configurations are:
- `torchic` - Personal laptop configuration
- `flareon` - Personal laptop configuration (new)
- `snorlax` - Work laptop configuration
- `infernape` - Personal desktop configuration

## Commands (once initially built)

### Apply System Configuration
```bash
nh os switch /home/hackr/nixos
```

### Test Configuration
```bash
nh os test /home/hackr/nixos
```

### Show Available Configurations
```bash
nix flake show
```

## Ubuntu Setup

A setup script is available for replicating the nushell shell environment on Ubuntu hosts (without Nix). It installs the same tools and config files:

- **nushell** (with plugins) — main shell
- **carapace** — completions
- **atuin** — shell history
- **starship** — prompt (poimandres theme)
- **zoxide** — directory jumping
- **direnv** — environment loading
- **fastfetch** — system info
- **pokeget-rs** — Pokémon sprites for pokefetch

```bash
curl -sL https://raw.githubusercontent.com/0xhckr/hackr-nixos/main/scripts/ubuntu-setup.sh | bash
```

On first run, the script will prompt whether to reset existing config files (defaults to no).

## Applications & Tools

The configuration includes:
- **Window Manager**: Niri (Wayland compositor) (with gde as a backup)
- **Shell**: Nushell with extensions
- **Development**: Cursor with extensions and keybindings (working on moving to [helix](https://github.com/helix-editor/helix))
- **Terminal**: [ghostty](https://ghostty.org/) as primary with [alacritty](https://alacritty.org/) as a backup
- **System Tools**: btop, fastfetch, atuin, and other utilities

## Customizations

The configuration uses a custom theme (rose-pine) applied consistently across:
- Shell environments
- Terminal applications
- Text editors
- Window management
- System appearance

### Pi (AI Coding Agent)

[Pi](https://github.com/earendil-works/pi-mono) is customized with custom themes, extensions, and settings managed declaratively via Nix. Source-of-truth files live in `cfg/pi/` and are symlinked into `~/.pi/agent/` by Home Manager, with an activation script that copies them to mutable live paths (so Pi can write to them at runtime).

#### Settings

`settings-original.json` → `~/.pi/agent/settings.json`

- **Provider**: `zai` (default AI provider)
- **Model**: `glm-5.1` (default model)
- **Thinking level**: `medium`
- **Theme**: `hackr` (custom theme, see below)
- **Quiet startup**: enabled
- **Package manager**: `bun` (for extension dependencies)
- **Global package**: `pi-super-curl` (via npm)

#### Themes

Two custom TUI themes are installed into `~/.pi/agent/themes/`:

- **`rose-pine.json`** — A faithful port of the [Rosé Pine](https://rosepin.e) colorscheme, with 16 named palette vars and full color mappings for the TUI (syntax highlighting, tool output, markdown rendering, thinking indicators, etc.).

- **`hackr.json`** — A bespoke dark theme built on the "Charmtone Pantera" palette. Named after food-themed colors (charple, dolly, bok, sriracha, malibu, julep, mustard, etc.) with a dark pepper/bbq/charcoal base. This is the active theme used by the Hackr UI extension.

#### Extensions

Three custom extensions are deployed to `~/.pi/agent/extensions/` with their npm dependencies installed via `bun`:

- **`hackr-ui.ts`** — A full TUI makeover that replaces Pi's default interface with a Charm-inspired aesthetic:
  - **Header**: Renders pi (π) digits as a `charple → dolly` gradient wordmark, with model name and cwd on the right
  - **Footer**: Token stats (input ↑ / output ↓ / cost $) on the left, model + git branch + cwd on the right
  - **Working indicator**: Gradient-animated `xoxo` pulse cycling between charple and dolly
  - **Custom editor**: `xoxo` prompt prefix (or `yolo` in YOLO mode), no visible borders, context window usage stats in the bottom bar
  - **`/yolo` command**: Toggles YOLO mode — auto-accepts all tool permissions and shows a bright yellow `! YOLO` status badge. Still blocks genuinely dangerous commands (`rm -rf`, `sudo`, `chmod 777`) with an interactive confirmation dialog
  - **`/hackr-ui` command**: Toggles the entire Hackr UI on/off

- **`jj-desc.ts`** — Adds a `jj_describe` tool and `/jj-desc` command that reads the current `jj diff`, sends it to the model to generate a concise commit description (imperative mood, <72 char summary, optional bullet details), then sets it via `jj describe`

- **`web-fetch.ts`** — A curl-backed `web_fetch` tool for fetching URL content (web pages, API responses, remote files). Supports GET/POST/PUT/DELETE, custom headers, request body, and configurable max response length

#### Deployment Pattern

The `links.nix` module handles two phases:

1. **Symlink** (declarative): `home.file` entries link `cfg/pi/*` → `~/.pi/agent/*-original.*`
2. **Activation script** (post-generation): Copies `-original` files to their live mutable paths, installs extension npm dependencies with `bun`, and sets writable permissions
