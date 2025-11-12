{
  description = "NixOS config for all of the systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, nixpkgs, nixos-hardware }:
    let
      mkHost = { hostname, system, extraModules ? [] }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/${hostname}/configuration.nix

            # ({ pkgs, ... }: { nixpkgs.hostPlatform = system; })

            # Shared options go here
            ({ ... }: {
              nixpkgs.config.allowUnfree = true;
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

