# NixOS Configuration - Agent Instructions

## Commands
- **Apply config**: `nh os switch ~/nixos` (or `sudo nixos-rebuild switch --flake .#<hostname>`)
- **Test config**: `nh os test ~/nixos`
- **Check syntax**: `nix flake check`
- **Show configs**: `nix flake show`
- Hosts: `infernape`, `torchic`, `snorlax`

## Architecture
- `flake.nix` - Main entry point, defines inputs and host configurations
- `hosts/<name>/` - Host-specific configs (hardware, boot, system settings)
- `modules/nixos/` - System-level modules (apps, settings, styles, system)
- `modules/home-manager/` - User-level modules (shell, editors, UI, apps)
- `cfg/` - Static config files sourced by modules (ghostty, niri, nushell, etc.)

## Code Style
- Use Nix language conventions with 2-space indentation
- Reference packages via `pkgs.<name>` or `lib.getExe pkgs.<name>`
- Use `${...}` interpolation for package paths in shell scripts
- Prefer `lib.mkForce` for overriding inherited values
- Keep modules focused; import via `default.nix` files
- Static configs go in `cfg/`, Nix expressions in `modules/`
