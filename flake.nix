{
  description = "NixOS config for all of the systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      t480 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ ... }: {
            nixpkgs.overlays = (import ./overlays) ++ [ ];
          })
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
          ./hosts/t480/configuration.nix
          inputs.home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.pgattic = import ./home/pgattic.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };

      corlessfam = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ ... }: {
            nixpkgs.overlays = (import ./overlays/mineclonia-game.nix) ++ [ ];
          })
          ./hosts/corlessfam/configuration.nix
        ];
      };

      cyberpi = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ({ ... }: {
            nixpkgs.overlays = (import ./overlays) ++ [ ];
          })
          inputs.nixos-hardware.nixosModules.raspberry-pi-4
          ./hosts/cyberpi/configuration.nix
        ];
      };
    };
  };
}

