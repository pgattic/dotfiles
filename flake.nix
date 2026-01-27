{
  description = "NixOS config for all of the systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:8bitbuddhist/nixos-hardware?ref=surface-rust-target-spec-fix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
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
          inputs.stylix.nixosModules.stylix
          ./hosts/t480
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.pgattic = import ./home/hosts/t480.nix;
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };

      surface = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ ... }: {
            nixpkgs.overlays = (import ./overlays) ++ [ ];
          })
          inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
          inputs.stylix.nixosModules.stylix
          ./hosts/surface
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.pgattic = import ./home/hosts/surface.nix;
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };

      corlessfam = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ ... }: {
            nixpkgs.overlays = (import ./overlays) ++ [ ];
          })
          ./hosts/corlessfam
        ];
      };

      cyberpi = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ({ ... }: {
            nixpkgs.overlays = (import ./overlays) ++ [ ];
          })
          inputs.nixos-hardware.nixosModules.raspberry-pi-4
          inputs.stylix.nixosModules.stylix
          ./hosts/cyberpi
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.pgattic = import ./home/hosts/cyberpi.nix;
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };
    };
  };
}

