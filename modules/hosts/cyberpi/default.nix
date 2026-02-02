{ config, inputs, ... }: {
  flake.nixosConfigurations.cyberpi = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      ./_hardware.nix
      inputs.nixos-hardware.nixosModules.raspberry-pi-4
      inputs.home-manager.nixosModules.home-manager

      ({ pkgs, ... }: {
        boot.loader.grub.enable = false;
        boot.loader.generic-extlinux-compatible.enable = true;

        hardware.raspberry-pi."4".fkms-3d.enable = true; # display output
        hardware.raspberry-pi."4".touch-ft5406.enable = true; # touchscreen input
        hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = true;

        hardware.graphics = {
          enable = true;
          extraPackages = with pkgs; [ mesa ];
        };

        hardware.deviceTree.enable = true;

        networking.hostName = "cyberpi"; # Define your hostname.
        networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

        programs = {
          firefox.enable = true;
          thunar.enable = true;
          xfconf.enable = true;
        };

        services = {
          mullvad-vpn.enable = true;
        };
        system.stateVersion = "25.05";
      })

      config.flake.modules.nixos.default
      config.flake.modules.nixos.desktop-default

      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit inputs; };
          users.${config.my.user.name} = {
            imports = [
              config.flake.modules.homeManager.default
              config.flake.modules.homeManager.desktop-default

              ({ pkgs, ... }: {
                home.packages = with pkgs; [
                  luanti-client
                  ungoogled-chromium
                ];
                programs.niri.settings.input.mod-key = "Alt";
              })
            ];
          };
        };
      }
    ];
  };
}

