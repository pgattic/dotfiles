{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.surface = withSystem "x86_64-linux" ({ self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
      inputs.self.nixosModules.options
      inputs.self.nixosModules.remote-builder
      inputs.self.nixosModules.default
      inputs.self.nixosModules.desktop-default
      inputs.self.nixosModules.zeditor
      inputs.self.nixosModules.browser

      ({ pkgs, ... }: {
        networking.hostName = "surface";
        system.stateVersion = "25.05";

        # Enable power button, volume rocker
        boot.initrd.kernelModules = [ "pinctrl_sunrisepoint" ]; # lsmod | grep pinctrl

        environment.systemPackages = [
          self'.packages.foot-rude
          self'.packages.luanti-client
          self'.packages.desktop
          self'.packages.sioyek
          self'.packages.neovim
          self'.packages.btop
          self'.packages.git
          pkgs.lazygit
          pkgs.rnote
        ];

        programs.niri = {
          enable = true;
          useNautilus = false;
          package = self'.packages.niri-touch.apply ({ lib, ... }: {
            settings.spawn-at-startup = [ [ (lib.getExe self'.packages.lisgd-surface) ] ];
          }).wrapper;
        };
      })
    ];
  });
}

