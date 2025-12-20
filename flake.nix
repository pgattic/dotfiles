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
          ./hosts/t480/configuration.nix
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
          inputs.home-manager.nixosModules.home-manager

          ({ ... }: {
            nixpkgs.overlays = (import ./overlays) ++ [ ];

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.pgattic = import ./home/pgattic.nix;
            };
          })
        ];
      };

      cyberpi = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./hosts/cyberpi/configuration.nix
          inputs.nixos-hardware.nixosModules.raspberry-pi-4

          ({ ... }: {
            nixpkgs.overlays = (import ./overlays) ++ [ ];
          })
        ];
      };
    };
  };
}

