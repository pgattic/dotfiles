{ config, inputs, ... }: {
  flake.nixosConfigurations.surface = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_hardware.nix
      inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
      inputs.home-manager.nixosModules.home-manager

      ({ pkgs, ... }: {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        hardware.microsoft-surface.kernelVersion = "stable";

        networking.hostName = "surface";

        programs = {
          firefox.enable = true;
        };

        services = {
          upower.enable = true;
          mullvad-vpn.enable = true;
        };
        system.stateVersion = "25.05";
      })

      config.flake.nixosModules.default
      config.flake.nixosModules.desktop-default
      config.flake.nixosModules.zeditor

      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit inputs; };
          users.${config.my.user.name} = {
            imports = [
              config.flake.modules.homeManager.default
              config.flake.modules.homeManager.desktop-default
              config.flake.modules.homeManager.zeditor

              ({ pkgs, ... }: {
                home.packages = with pkgs; [
                  ungoogled-chromium
                  luanti-client
                ];
              })
            ];
          };
        };
      }
    ];
  };
}

