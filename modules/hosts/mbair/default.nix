{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.mbair = withSystem "aarch64-linux" ({ pkgs, self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
      inputs.self.nixosModules.options
      inputs.self.nixosModules.default
      inputs.self.nixosModules.desktop-default
      inputs.self.nixosModules.browser

      ({ config, pkgs, ... }: {
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
          inputs.wasmcarts.packages.${pkgs.stdenv.hostPlatform.system}.engine-linux
          pkgs.signal-desktop
        ];

        home-manager.users.${config.my.user.name}.programs = {
          vesktop.enable = true;
          niri.settings = {
            outputs."eDP-1".scale = 1.5;
            input.touchpad.dwt = true;
            layout.shadow.enable = true;
          };
          noctalia-shell = {
            plugins.states.activate-linux = {
              sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
              enabled = true;
            };
            pluginSettings.activate-linux = {
              customizeText = true;
              firstLine = "Activate Linux";
              secondLine = "Go to Settings to activate Linux.";
            };
          };
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

