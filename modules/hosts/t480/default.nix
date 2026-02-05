{ config, lib, inputs, ... }: {
  flake.nixosConfigurations.t480 = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_hardware.nix
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
      inputs.home-manager.nixosModules.home-manager

      ({ pkgs, ... }: {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        networking.hostName = "t480";

        users.users.${config.my.user.name}.extraGroups = lib.mkAfter [
          "kvm"
          "adbusers"
          "docker"
          "input"
        ];

        programs = {
          kdeconnect.enable = true;

          appimage.enable = true;
          appimage.binfmt = true;
        };

        virtualisation.docker.enable = true;

        services = {
          upower.enable = true;
          flatpak.enable = true; # Only good source for Zen Browser
          syncthing = {
            enable = true;
            user = "pgattic";
            openDefaultPorts = true;
            dataDir = config.my.user.home_dir;
          };
          mullvad-vpn.enable = true;
        };
        system.stateVersion = "25.05";
      })

      config.flake.nixosModules.default
      config.flake.nixosModules.desktop-default
      config.flake.nixosModules.work
      config.flake.nixosModules.zeditor
      config.flake.nixosModules.browser

      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit inputs; };
          users.${config.my.user.name} = {
            imports = [
              config.flake.homeModules.default
              config.flake.homeModules.desktop-default
              config.flake.homeModules.work
              config.flake.homeModules.zeditor
              config.flake.homeModules.browser

              ({ pkgs, ... }: {
                home.packages = with pkgs; [
                  mcpelauncher-ui-qt
                  obsidian
                  ungoogled-chromium
                  qbittorrent
                  bambu-studio
                  # nicotine-plus # Soulseek client
                  pinta
                  antigravity-fhs

                  luanti-client
                  prismlauncher
                  # antimicrox
                  # calibre

                  vscode
                  zoom-us
                  ventoy

                  waypipe
                  signal-desktop
                  openscad
                ];

                xdg.mimeApps.defaultApplications = {
                  "x-scheme-handler/sgnl" = "signal.desktop";
                  "x-scheme-handler/signalcaptcha" = "signal.desktop";
                };

                programs = {
                  vesktop.enable = true;
                  helix.enable = true;
                  niri.settings.outputs."eDP-1".scale = 1.0;
                };
              })
            ];
          };
        };
      }
    ];
  };
}
