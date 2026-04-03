{ config, inputs, ... }: {
  flake.nixosConfigurations.mbair = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      ./_hardware.nix
      inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
      config.flake.nixosModules.options
      config.flake.nixosModules.default
      config.flake.nixosModules.desktop-default
      config.flake.nixosModules.browser

      ({ config, ... }: {
        networking.hostName = "mbair";
        system.stateVersion = "25.11";
        # Use `--impure` while building
        hardware.asahi.peripheralFirmwareDirectory = /etc/nixos/firmware;

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
        home-manager.users.${config.my.user.name}.imports = [
          ({ pkgs, ... }: {
            home.packages = with pkgs; [
              luanti-client
              inputs.wasmcarts.packages.${stdenv.hostPlatform.system}.engine-linux
            ];
            programs = {
              vesktop.enable = true;
              niri.settings = {
                outputs."eDP-1".scale = 1.5;
                input.touchpad.dwt = true;
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
            };
          })
        ];
      })
    ];
  };
}

