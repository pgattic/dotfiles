{
  description = "NixOS config for all of the systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, nixpkgs, nixos-hardware }:
    let
      default-overlays = import ./overlays;

      mkHost = { hostname, system, extraModules ? [] }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/${hostname}/configuration.nix

            # Shared options
            ({ ... }: {
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = default-overlays;
            })
          ] ++ extraModules;
        };
    in
      {
      nixosConfigurations = {
        t480 = mkHost {
          hostname = "t480";
          system = "x86_64-linux";
        };
        cyberpi = mkHost {
          hostname = "cyberpi";
          system = "aarch64-linux";
          extraModules = [
            nixos-hardware.nixosModules.raspberry-pi-4
          ];
        };
      };
    };
}

