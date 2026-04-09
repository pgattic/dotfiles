{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.surface = withSystem "x86_64-linux" ({ pkgs, self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
      inputs.self.nixosModules.options
      inputs.self.nixosModules.default
      inputs.self.nixosModules.desktop-default
      inputs.self.nixosModules.zeditor
      inputs.self.nixosModules.browser

      ({ config, pkgs, ... }: {
        # Enable power button, volume rocker
        boot.initrd.kernelModules = [ "pinctrl_sunrisepoint" ]; # lsmod | grep pinctrl

        networking.hostName = "surface";
        system.stateVersion = "25.05";

        my.desktop.touch_options = true;

        programs.niri = {
          enable = true;
          useNautilus = false;
          package = self'.packages.niri-touch;
        };

        environment.systemPackages = [
          self'.packages.luanti-client
          self'.packages.foot-rude
          pkgs.rnote
        ];
      })
    ];
  });
}

