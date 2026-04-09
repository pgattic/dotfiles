{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.cyberpi = withSystem "aarch64-linux" ({ pkgs, self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      inputs.nixos-hardware.nixosModules.raspberry-pi-4
      inputs.self.nixosModules.options
      inputs.self.nixosModules.default
      inputs.self.nixosModules.desktop-default

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
        services.upower.enable = false;
        hardware.bluetooth.enable = false;

        my.desktop.touch_options = true;

        environment.systemPackages = [
          self'.packages.foot-rude
          self'.packages.luanti-client
        ];

        programs.niri = {
          enable = true;
          useNautilus = false;
          package = self'.packages.niri-touch;
        };

        home-manager.users.${config.my.user.name}.programs = {
          chromium = {
            enable = true;
            package = pkgs.ungoogled-chromium;
          };
          niri.settings.input.mod-key = "Alt";
        };
      })
    ];
  });
}

