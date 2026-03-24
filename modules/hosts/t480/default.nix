{ config, inputs, ... }: {
  flake.nixosConfigurations.t480 = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_hardware.nix
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480

      config.flake.nixosModules.options
      config.flake.nixosModules.default
      config.flake.nixosModules.desktop-default
      config.flake.nixosModules.work
      config.flake.nixosModules.zeditor
      config.flake.nixosModules.browser
      config.flake.nixosModules.office
      config.flake.nixosModules.obsidian

      ({ config, lib, ... }: {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        networking.hostName = "t480";

        programs = {
          nix-ld.enable = true;
          appimage.enable = true;
          appimage.binfmt = true;
        };
        services = {
          mullvad-vpn.enable = true;
        };

        system.stateVersion = "25.05";

        home-manager.users.${config.my.user.name}.imports = [
          ({ pkgs, ... }: {
            home.packages = with pkgs; [
              pinta
              antigravity-fhs
              luanti-client
              zoom-us
              ventoy
              signal-desktop
              zotero
              bambu-studio
              inputs.wasmcarts.packages.${stdenv.hostPlatform.system}.engine-linux
            ];

            programs = {
              vesktop.enable = true;
              claude-code.enable = true;
              element-desktop.enable = true;
              # calibre.enable = true;
              # prismlauncher.enable = true;
              # helix.enable = true;
              chromium = {
                enable = true;
                package = pkgs.ungoogled-chromium;
              };
              niri.settings.outputs."eDP-1".scale = 1.0;
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

            services = {
              kdeconnect.enable = true;
            };
          })
        ];
      })
    ];
  };
}

