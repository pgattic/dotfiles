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

      ({ config, pkgs, ... }: {
        networking.hostName = "t480";
        system.stateVersion = "25.05";

        zramSwap.enable = false; # This machine has a swap partition
        programs = {
          nix-ld.enable = true;
          appimage.enable = true;
          appimage.binfmt = true;
        };
        services = {
          mullvad-vpn.enable = true;
        };

        home-manager.users.${config.my.user.name} = {
          home.packages = with pkgs; [
            pinta
            antigravity-fhs
            luanti-client
            zoom-us
            ventoy
            signal-desktop
            whatsapp-electron
            zotero
            bambu-studio
            inputs.wasmcarts.packages.${stdenv.hostPlatform.system}.engine-linux
          ];

          programs = {
            vesktop.enable = true;
            # claude-code.enable = true;
            element-desktop.enable = true;
            # calibre.enable = true;
            # prismlauncher.enable = true;
            # helix.enable = true;
            chromium = {
              enable = true;
              package = pkgs.ungoogled-chromium;
            };
            ripgrep-all.enable = true;
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
            jujutsu = {
              enable = true;
              settings = {
                user = { inherit (config.my.user) name email; };
                ui = {
                  default-command = [ "log" "--reversed" ];
                  paginate = "never";
                };
              };
            };
            jjui = {
              enable = true;
            };
          };

          services = {
            kdeconnect.enable = true;
          };
        };
      })
    ];
  };
}

