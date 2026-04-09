{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.mbair = withSystem "aarch64-linux" ({ pkgs, self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
      inputs.self.nixosModules.options
      inputs.self.nixosModules.default
      inputs.self.nixosModules.desktop-default
      inputs.self.nixosModules.browser

      ({ config, lib, pkgs, ... }: {
        networking.hostName = "mbair";
        system.stateVersion = "25.11";
        # Use `--impure` while building
        hardware.asahi.peripheralFirmwareDirectory = /etc/nixos/firmware;

        zramSwap.enable = false; # Needs more
        swapDevices = [{
          device = "/var/lib/swapfile";
          size = 16*1024; # 16 GiB
        }];

        # Uncomment this to support WPA3 (at the cost of some other connections working)
        # networking.networkmanager.wifi.backend = "iwd";
        # networking.wireless.iwd = {
        #   enable = true;
        #   settings.General.EnableNetworkConfiguration = true;
        # };

        nix.settings = {
          substituters = [ "https://nixos-apple-silicon.cachix.org" ];
          trusted-public-keys = [ "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20=" ];
        };

        environment.systemPackages = [
          self'.packages.foot-rude
          self'.packages.luanti-client
          self'.packages.desktop
          inputs.wasmcarts.packages.${pkgs.stdenv.hostPlatform.system}.engine-linux
          pkgs.signal-desktop
        ];

        programs = {
          git = {
            enable = true;
            package = self'.packages.git;
          };
          lazygit.enable = true;
          niri = {
            enable = true;
            useNautilus = false;
            package = (self'.packages.niri-activate-linux.apply {
              settings = {
                outputs."eDP-1".scale = 1.5;
                # input.touchpad.dwt = lib.mkAfter (_: {}); # TODO: Make this merge properly
              };
            }).wrapper;
          };
        };

        home-manager.users.${config.my.user.name}.programs = {
          vesktop.enable = true;
          chromium = {
            enable = true;
            package = pkgs.ungoogled-chromium;
          };
          codex.enable = true;
        };
      })
    ];
  });
}

