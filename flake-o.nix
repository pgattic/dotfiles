{
  description = "NixOS config for all of the systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      corlessfam = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ ... }: {
            nixpkgs.overlays = (import ./overlays) ++ [ ];
          })
          ./hosts/corlessfam
        ];
      };
    };
  };
}

