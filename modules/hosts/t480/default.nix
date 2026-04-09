{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.surface = withSystem "x86_64-linux" ({ pkgs, self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
      inputs.self.nixosModules.options
      inputs.self.nixosModules.default
      inputs.self.nixosModules.desktop-default
      inputs.self.nixosModules.work
      inputs.self.nixosModules.zeditor
      inputs.self.nixosModules.browser
      inputs.self.nixosModules.office
      inputs.self.nixosModules.obsidian

      ({ config, pkgs, ... }: {
        networking.hostName = "t480";
        system.stateVersion = "25.05";

        zramSwap.enable = false; # This machine has a swap partition
        programs = {
          nix-ld.enable = true;
          appimage.enable = true;
          appimage.binfmt = true;
          niri = {
            enable = true;
            useNautilus = false;
            package = (self'.packages.niri-activate-linux.apply {
              settings = {
                outputs."eDP-1".scale = 1.0;
              };
            }).wrapper;
          };
        };
        services = {
          mullvad-vpn.enable = true;
        };

        environment.systemPackages = with pkgs; [
          self'.packages.foot-rude
          pinta
          antigravity-fhs
          self'.packages.luanti-client
          zoom-us
          ventoy
          signal-desktop
          whatsapp-electron
          zotero
          self'.packages.bambu-studio
          inputs.wasmcarts.packages.${stdenv.hostPlatform.system}.engine-linux
        ];

        home-manager.users.${config.my.user.name} = {
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
  });
}

