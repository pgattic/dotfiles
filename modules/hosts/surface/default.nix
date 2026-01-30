{ config, lib, inputs, ... }: {
  config = {
    flake.nixosConfigurations.surface = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./_hardware.nix
        inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
        inputs.home-manager.nixosModules.home-manager
        { nixpkgs.overlays = import ../../../overlays; }

        ({ pkgs, ... }: {

          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;

          networking.hostName = "surface";
          hardware.bluetooth = {
            enable = true;
            powerOnBoot = false;
            settings.General.Experimental = true;
          };

          hardware.microsoft-surface.kernelVersion = "stable";
          networking.networkmanager.enable = true;

          users.users.${config.my.user.name}.extraGroups = lib.mkAfter [
          ];

          programs = {
            firefox.enable = true;
          };

          environment.sessionVariables = {
            NIXOS_OZONE_WL = "1";
          };

          services = {
            fwupd.enable = true; # Firmware update manager
            upower.enable = true;
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
                    zed-editor
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
  };
}
