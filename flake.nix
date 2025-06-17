{
  description = "Nixos config flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cosmic-session = {
      url = "github:bluelinden/cosmic-session";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cosmic-ext-alternative-startup = {
      url = "github:bluelinden/cosmic-ext-alternative-startup";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    swww = {
      url = "github:LGFae/swww";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    affinity-nix = {
      url = "github:mrshmllow/affinity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "github:quickshell-mirror/quickshell";
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

    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    astal = {
      url = "github:Aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sherlock = {
      url = "git+file:///home/hackr/dev/sherlock";
      # type = "github";
      # owner = "Skxxtz";
      # repo = "sherlock";
      # ref = "unstable/release-v0.1.13";
      # inputs.nixpkgs.follows = "nixpkgs";
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
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      lanzaboote,
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
            lanzaboote.nixosModules.lanzaboote
            ./hosts/hackrpc/lanzaboote.nix
            ./hosts/hackrpc/configuration.nix
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
      darwinConfigurations = {
        hackrmbp = nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs;
            system = "aarch64-darwin";
          };
          modules = [
            ./hosts/hackrmbp/configuration.nix
            ./modules/home-manager/default.nix
            inputs.home-manager.darwinModules.default
          ];
        };
      };
    };
}
