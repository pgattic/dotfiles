{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.op6 = withSystem "aarch64-linux" ({ self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      (import "${inputs.mobile-nixos}/lib/configuration.nix" { device = "oneplus-enchilada"; })
      inputs.self.nixosModules.options
      inputs.self.nixosModules.default
      inputs.self.nixosModules.desktop-default

      ({ pkgs, ... }: {
        networking.hostName = "op6";
        system.stateVersion = "26.05";
        boot.loader.systemd-boot.enable = false; # Overriding from base

        services.logind.settings.Login = {
          HandlePowerKey = "ignore"; # The kernel handles this already
          HandlePowerKeyLongPress = "poweroff";
        };

        environment.systemPackages = [
          self'.packages.foot-rude
          self'.packages.luanti-client
          self'.packages.desktop
          self'.packages.neovim
          self'.packages.sioyek
          self'.packages.btop
          self'.packages.git
          pkgs.signal-desktop
          pkgs.lazygit
          pkgs.librewolf
        ];

        users.users.pgattic.shell = self'.packages.nushell-env;

        programs.niri = {
          enable = true;
          useNautilus = false;
          package = self'.packages.niri-mobile.apply ({ lib, ... }: {
            settings = {
              spawn-at-startup = [ [ (lib.getExe self'.packages.lisgd-op6) ] ];
              outputs."DSI-1".scale = 2.0;
            };
          }).wrapper;
        };

        services = {
          openssh = {
            enable = true;
            settings.PasswordAuthentication = true;
          };
          displayManager.gdm.enable = true;
          greetd.enable = false; # Overriding from desktop-base
        };
      })
    ];
  });
}

