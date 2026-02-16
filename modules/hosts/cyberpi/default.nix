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

        networking.hostName = "cyberpi";

        programs = {
          firefox.enable = true;
          thunar.enable = true;
          xfconf.enable = true;
        };

        services = {
          mullvad-vpn.enable = true;
        };
        system.stateVersion = "25.05";

        my.desktop.touch_options = true;

        home-manager.users.${config.my.user.name}.imports = [
          ({ pkgs, ... }: {
            home.packages = with pkgs; [
              luanti-client
              ungoogled-chromium
              rnote
            ];
            programs.niri.settings.input.mod-key = "Alt";
          })
        ];
      })
    ];
  };
}

