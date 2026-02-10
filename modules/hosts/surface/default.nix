{ config, inputs, ... }: {
  flake.nixosConfigurations.surface = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_hardware.nix
      config.flake.nixosModules.options
      inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel

      { my.desktop.touch_options = true; }

      {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        hardware.microsoft-surface.kernelVersion = "stable";

        networking.hostName = "surface";

        services = {
          mullvad-vpn.enable = true;
        };
        system.stateVersion = "25.05";
      }

      config.flake.nixosModules.default
      config.flake.nixosModules.desktop-default
      config.flake.nixosModules.zeditor
      config.flake.nixosModules.browser

      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit inputs; };
          users.pgattic = {
            imports = [
              config.flake.homeModules.default
              config.flake.homeModules.desktop-default
              config.flake.homeModules.zeditor
              config.flake.homeModules.browser

              ({ pkgs, ... }: {
                home.packages = with pkgs; [
                  luanti-client
                  rnote
                ];
              })
            ];
          };
        };
      }
    ];
  };
}

