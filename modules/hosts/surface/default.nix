{ config, inputs, ... }: {
  flake.nixosConfigurations.surface = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_hardware.nix
      inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel

      config.flake.nixosModules.options
      config.flake.nixosModules.default
      config.flake.nixosModules.desktop-default
      config.flake.nixosModules.zeditor
      config.flake.nixosModules.browser

      ({ config, ... }: {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        hardware.microsoft-surface.kernelVersion = "stable";

        networking.hostName = "surface";
        system.stateVersion = "25.05";

        my.desktop.touch_options = true;

        home-manager.users.${config.my.user.name}.imports = [
          ({ pkgs, ... }: {
            home.packages = with pkgs; [
              luanti-client
              rnote
            ];
          })
        ];
      })
    ];
  };
}

