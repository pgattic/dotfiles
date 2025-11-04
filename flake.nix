{
  description = "NixOS config for all of the systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;

        config = {
          allowUnfree = true;
        };
      };
    in
      {
      nixosConfigurations = {
        "t480" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit system; };
          modules = [
            ./hosts/t480/configuration.nix
          ];
        };
      };
    };
}

