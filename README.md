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

## Applications & Tools

The configuration includes:
- **Window Manager**: Niri (Wayland compositor) (with gde as a backup)
- **Shell**: Nushell with extensions
- **Development**: Cursor with extensions and keybindings (working on moving to [helix](https://github.com/helix-editor/helix))
- **Terminal**: [ghostty](https://ghostty.org/) as primary with [alacritty](https://alacritty.org/) as a backup
- **System Tools**: btop, fastfetch, atuin, and other utilities

## Customizations

The configuration uses a custom theme (poimandres) applied consistently across:
- Shell environments
- Terminal applications  
- Text editors
- Window management
- System appearance
