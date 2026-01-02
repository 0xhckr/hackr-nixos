# Crush NixOS Configuration Repository

This repository contains NixOS system configurations andz Home Manager user configurations. It uses the Nix package manager to declaratively configure systems.

## Project Structure

- `flake.nix` - Main flake file that defines the repository
- `hosts/` - System configurations for different machines
  - `hackrfrmw/` - Personal laptop configuration
  - `hackrwork/` - Work machine configuration  
  - `hackrpc/` - PC configuration
- `modules/nixos/` - NixOS system modules
- `modules/home-manager/` - Home Manager user configuration modules
- `cfg/` - User configuration files for various applications (atuin, btop, niri, etc.)
- `ssh/` - SSH key files and git configurations
- `patches/` - System patches

## Key Commands

### Building Systems
```bash
# Build a specific system configuration
nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel

# Example for hackrfrmw
nix build .#nixosConfigurations.hackrfrmw.config.system.build.toplevel
```

### Testing Changes
```bash
# Build and test the entire flake
nix flake check

# Run nix fmt to format files (if formatter available)
nix fmt
```

### Switching to New Configuration (requires root)
```bash
# Switch to the new system configuration
sudo nixos-rebuild switch --flake .#<hostname>
```

### Activating Home Manager Configuration
```bash
# Build just user configuration
home-manager build --flake .#<username>@<hostname>

# Switch to new home configuration
home-manager switch --flake .#<username>@<hostname>
```

### Local Development Commands
```bash
# Run nix develop if shell.nix available
nix develop

# Check flake validity
nix flake show
```

## Code Organization and Patterns

### Nix Style Conventions
- All configuration files use Nix language syntax with `.nix` extension
- Module patterns: Define options using `options` and implement in `config`
- Use let..in expressions for local bindings
- Prefer attrset over recursive let for complex configurations

### Module Structure
- `modules/nixos/` contains system-level modules
- `modules/home-manager/` contains user-level modules
- Each module follows declarative configuration patterns
- Host-specific settings in `hosts/<hostname>/`

### Common Patterns
- Use `mkIf` for conditional configuration
- Use `mkMerge` to combine multiple configurations
- Module options follow naming conventions e.g. `services.ssh.enable`

## Build and Development Workflow

1. Make changes to configuration files
2. Test build with `nix build` or `nix flake check`
3. Apply with `nixos-rebuild switch --flake .#<hostname>` (system) or `home-manager switch --flake .#<username>@<hostname>` (user)

## Gotchas and Important Notes

- All changes are system-wide and can affect the entire system operation
- Test changes on non-production machines first
- Remember to include both system and user configurations when making changes
- NixOS rebuilds may take time and require root access
- Configuration syntax errors will prevent system updates
- Always backup important configuration before making system-wide changes
- The system uses Wayland compositor niri and applications are largely configured declaratively