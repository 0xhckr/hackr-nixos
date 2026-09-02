# NixOS configuration

<img width="2880" height="1920" alt="image" src="https://github.com/user-attachments/assets/178cd0b7-213e-44a7-8863-edf453711c4f" />


My NixOS system and Home Manager configs for all my machines. Everything is managed declaratively with Nix: apps, services, shell, theming, the works.

## Structure

- `hosts/` - per-machine configs (desktop, laptops, work machine)
- `modules/nixos/` - system-level modules (apps, services, settings)
- `modules/home-manager/` - user-level modules (shell, editors, UI)
- `cfg/` - static config files symlinked into place
- `ssh/` - SSH configs and keys

## Hosts

Defined in `hosts/`:
- `infernape` - desktop
- `flareon` - laptop (new)
- `snorlax` - work laptop

## Installing

Only really useful to me, but if that's you: you need a NixOS install. Home Manager comes along as a NixOS module, so there's nothing separate to set up.

1. Clone this repository
2. `cd` into it
3. Apply the system configuration:
   ```bash
   sudo nixos-rebuild switch --flake .#<hostname>
   ```

## Everyday commands

Apply the config:
```bash
nh os switch /home/hackr/nixos
```

Test without activating:
```bash
nh os test /home/hackr/nixos
```

Show available configurations:
```bash
nix flake show
```

## Ubuntu setup

`scripts/ubuntu-setup.sh` replicates my nushell environment on Ubuntu hosts, no Nix required. It installs the same tools and config files:

- **nushell.** The shell, with plugins.
- **carapace.** Completions.
- **atuin.** Shell history.
- **starship.** Prompt, poimandres theme.
- **zoxide.** Directory jumping.
- **direnv.** Environment loading.
- **fastfetch.** System info.
- **pokeget-rs.** Pokémon sprites for pokefetch.

```bash
curl -sL https://raw.githubusercontent.com/0xhckr/hackr-nixos/main/scripts/ubuntu-setup.sh | bash
```

On first run it asks whether to reset existing config files (defaults to no).

## What's in here

- **Window manager.** niri (Wayland compositor), with gde as a backup.
- **Shell.** nushell with extensions.
- **Editor.** Cursor with my extensions and keybindings, though I'm moving to [helix](https://github.com/helix-editor/helix).
- **Terminal.** [ghostty](https://ghostty.org/) as primary, [alacritty](https://alacritty.org/) as backup.
- **System tools.** btop, fastfetch, atuin, and the usual utilities.

Everything is themed rose-pine: shell, terminals, editors, window manager, system appearance. One palette, everywhere.

## Pi (AI coding agent)

[Pi](https://github.com/earendil-works/pi-mono) gets custom themes, extensions, and settings, all managed through Nix. The source files live in `cfg/pi/` and Home Manager symlinks them into `~/.pi/agent/`. An activation script then copies them to mutable live paths so Pi can write to them at runtime.

### Settings

`settings-original.json` → `~/.pi/agent/settings.json`

- Provider: `zai`
- Model: `glm-5.2`
- Thinking level: `medium`
- Theme: `hackr` (custom, see below)
- Quiet startup: on
- Package manager: `bun`, for extension dependencies
- Global package: `pi-super-curl` (via npm)

### Themes

Two custom TUI themes land in `~/.pi/agent/themes/`:

- **`rose-pine.json`.** A port of the [Rosé Pine](https://rosepinetheme.com) colorscheme, with 16 named palette vars and full color mappings for the TUI (syntax highlighting, tool output, markdown rendering, thinking indicators, etc.).
- **`hackr.json`.** A dark theme built on the "Charmtone Pantera" palette. The colors are named after food (charple, dolly, bok, sriracha, malibu, julep, mustard) over a dark pepper/bbq/charcoal base. This is the active theme, used by the Hackr UI extension.

### Extensions

Three custom extensions go into `~/.pi/agent/extensions/`, with npm dependencies installed via `bun`:

- **`hackr-ui.ts`.** Replaces Pi's default TUI with a Charm-inspired look:
  - Header: pi (π) digits rendered as a charple → dolly gradient wordmark, model name and cwd on the right
  - Footer: token stats (input ↑ / output ↓ / cost $) on the left, model + git branch + cwd on the right
  - Working indicator: gradient-animated `xoxo` pulse cycling between charple and dolly
  - Custom editor: `xoxo` prompt prefix (`yolo` in YOLO mode), no visible borders, context window stats in the bottom bar
  - `/yolo` command: toggles YOLO mode, which auto-accepts all tool permissions and shows a bright yellow `! YOLO` status badge. Genuinely dangerous commands (`rm -rf`, `sudo`, `chmod 777`) still get blocked behind an interactive confirmation dialog
  - `/hackr-ui` command: toggles the whole thing on/off

- **`jj-desc.ts`.** Adds a `jj_describe` tool and `/jj-desc` command. Reads the current `jj diff`, asks the model for a commit description (imperative mood, <72 char summary, optional bullet details), then sets it via `jj describe`.

- **`web-fetch.ts`.** A curl-backed `web_fetch` tool for fetching URL content (web pages, API responses, remote files). Supports GET/POST/PUT/DELETE, custom headers, request bodies, and a configurable max response length.

### How deployment works

The `links.nix` module handles it in two phases:

1. **Symlink (declarative).** `home.file` entries link `cfg/pi/*` to `~/.pi/agent/*-original.*`.
2. **Activation script (post-generation).** Copies the `-original` files to their live mutable paths, installs extension npm dependencies with `bun`, and sets writable permissions.
