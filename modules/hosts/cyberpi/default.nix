{ config, inputs, ... }: {
  flake.nixosConfigurations.cyberpi = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      ./_hardware.nix
      inputs.nixos-hardware.nixosModules.raspberry-pi-4
      config.flake.nixosModules.options
      config.flake.nixosModules.default
      config.flake.nixosModules.desktop-default

      ({ config, pkgs, ... }: {
        boot.loader.systemd-boot.enable = false;
        boot.loader.efi.canTouchEfiVariables = false; # Might not matter if I set this

        hardware.raspberry-pi."4".fkms-3d.enable = true; # display output
        hardware.raspberry-pi."4".touch-ft5406.enable = true; # touchscreen input
        hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = true;
        hardware.deviceTree.enable = true;
        hardware.graphics = {
          enable = true;
          extraPackages = with pkgs; [ mesa ];
        };

        networking.hostName = "cyberpi";
        system.stateVersion = "25.05";
        services.fwupd.enable = false;

        my.desktop.touch_options = true;

        home-manager.users.${config.my.user.name}.imports = [
          ({ pkgs, ... }: {
            home.packages = with pkgs; [
              luanti-client
              rnote
            ];
            programs = {
              chromium = {
                enable = true;
                package = pkgs.ungoogled-chromium;
              };
              niri.settings.input.mod-key = "Alt";
            };
          })
        ];
      })
    ];
  };
}

