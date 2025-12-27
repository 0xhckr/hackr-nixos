{
  description = "Nixos config flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-25.11";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    awww = {
      url = "git+https://codeberg.org/LGFae/awww";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    affinity-nix = {
      url = "github:mrshmllow/affinity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-blurry = {
      type = "github";
      owner = "visualglitch91";
      repo = "niri";
      ref = "feat/blur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-unstable = {
      type = "github";
      owner = "YaLTeR";
      repo = "niri";
      ref = "main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:nix-community/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      type = "github";
      owner = "ghostty-org";
      repo = "ghostty";
      ref = "main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix4vscode = {
      url = "github:nix-community/nix4vscode";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    vicinae = {
      url = "github:vicinaehq/vicinae";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    commie = {
      url = "github:at-mojo/commie";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    _1password = {
      url = "github:1Password/shell-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    graphite = {
      url = "github:GraphiteEditor/Graphite?dir=.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    {
      # use "nixos", or your hostname as the name of the configuration
      # it's a better practice than "default" shown in the video
      nixosConfigurations = {
        hackrpc = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            system = "x86_64-linux";
          };
          modules = [
            ./hosts/hackrpc/boot.nix
            ./hosts/hackrpc/configuration.nix
            ./modules/home-manager/default.nix
            inputs.home-manager.nixosModules.default
            inputs.stylix.nixosModules.stylix
          ];
        };
        hackrfrmw = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            system = "x86_64-linux";
          };
          modules = [
            ./hosts/hackrfrmw/configuration.nix
            ./modules/home-manager/default.nix
            inputs.home-manager.nixosModules.default
            inputs.stylix.nixosModules.stylix
          ];
        };
        hackrwork = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            system = "x86_64-linux";
          };
          modules = [
            ./hosts/hackrwork/boot.nix
            ./hosts/hackrwork/configuration.nix
            ./modules/home-manager/default.nix
            inputs.home-manager.nixosModules.default
            inputs.stylix.nixosModules.stylix
          ];
        };
      };
    };
}
