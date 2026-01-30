{ config, lib, inputs, ... }: {
  config = {
    flake.nixosConfigurations.cyberpi = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ./_hardware.nix
        inputs.nixos-hardware.nixosModules.raspberry-pi-4
        inputs.home-manager.nixosModules.home-manager
        { nixpkgs.overlays = import ../../../overlays; }

        ({ pkgs, ... }: {
          # my.desktop = {
          #   enable = true;
          #   touch_options = true;
          #   niri = {
          #     enable = true;
          #     mod_key = "Alt";
          #   };
          #   noctalia.enable = true;
          #   portals.enable = true;
          #   stylix.enable = true;
          # };

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

          environment.sessionVariables = {
            NIXOS_OZONE_WL = "1";
          };

          services = {
            fwupd.enable = true; # Firmware update manager
            mullvad-vpn.enable = true;
          };
          system.stateVersion = "25.05";
        })

        config.flake.modules.nixos.base
        config.flake.modules.nixos.git
        config.flake.modules.nixos.neovim
        config.flake.modules.nixos.nushell
        config.flake.modules.nixos.user

        config.flake.modules.nixos.desktop
        config.flake.modules.nixos.niri
        config.flake.modules.nixos.noctalia
        config.flake.modules.nixos.portals
        config.flake.modules.nixos.stylix

        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            users.${config.my.user.name} = {
              imports = [
                config.flake.modules.homeManager.base
                config.flake.modules.homeManager.git
                config.flake.modules.homeManager.neovim
                config.flake.modules.homeManager.nushell
                config.flake.modules.homeManager.user

                config.flake.modules.homeManager.desktop
                config.flake.modules.homeManager.niri
                config.flake.modules.homeManager.noctalia
                config.flake.modules.homeManager.portals
                config.flake.modules.homeManager.stylix
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
  };
}
