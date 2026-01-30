{ config, lib, inputs, ... }: {
  config = {
    my.desktop = {
      enable = true;
      niri = {
        enable = true;
        outputs."eDP-1".scale = 1.0;
      };
      noctalia.enable = true;
      portals.enable = true;
      stylix.enable = true;
    };

    flake.nixosConfigurations.t480 = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./_hardware.nix
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
        inputs.home-manager.nixosModules.home-manager
        { nixpkgs.overlays = import ../../../overlays; }

        ({ pkgs, ... }: {
          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;
          boot.kernelModules = [ "uinput" ];

          networking.hostName = "t480";
          hardware.bluetooth = {
            enable = true;
            powerOnBoot = false;
            settings.General.Experimental = true;
          };

          networking.networkmanager.enable = true;

          users.users.${config.my.user.name}.extraGroups = lib.mkAfter [
            "kvm"
            "adbusers"
            "docker"
            "input"
            "dialout"
          ];

          hardware.uinput.enable = true; # Added alongside the "dialout" user group for work
          programs = {
            nix-ld.enable = true;
            nix-ld.libraries = with pkgs; [
              wayland
              wayland-protocols
            ];

            kdeconnect.enable = true;

            appimage.enable = true;
            appimage.binfmt = true;

            firefox = {
              enable = true;
              # policies = {
              #   ExtensionSettings = {
              #
              #   }
              # };
              preferences = {
                "browser.gesture.swipe.left" = "cmd_scrollLeft";
                "browser.gesture.swipe.right" = "cmd_scrollRight";
                "browser.uiCustomization.state" = ''
                  {
                    "placements": {
                      "widget-overflow-fixed-list": [],
                      "unified-extensions-area": [],
                      "nav-bar": [
                        "back-button",
                        "forward-button",
                        "stop-reload-button",
                        "customizableui-special-spring1",
                        "vertical-spacer",
                        "urlbar-container",
                        "customizableui-special-spring2",
                        "downloads-button",
                        "unified-extensions-button"
                      ],
                      "toolbar-menubar": [
                        "menubar-items"
                      ],
                      "TabsToolbar": [
                        "tabbrowser-tabs",
                        "new-tab-button"
                      ],
                      "vertical-tabs": [],
                      "PersonalToolbar": [
                        "import-button",
                        "personal-bookmarks"
                      ]
                    },
                    "seen": [
                      "developer-button",
                      "screenshot-button"
                    ],
                    "dirtyAreaCache": [
                      "nav-bar",
                      "vertical-tabs",
                      "toolbar-menubar",
                      "TabsToolbar",
                      "PersonalToolbar"
                    ],
                    "currentVersion": 23,
                    "newElementCount": 4
                  }
                '';
              };
            };
          };

          virtualisation.docker.enable = true;

          environment.sessionVariables = {
            NIXOS_OZONE_WL = "1";
          };

          services = {
            fwupd.enable = true; # Firmware update manager
            upower.enable = true;
            flatpak.enable = true; # Only good source for Zen Browser
            syncthing = {
              enable = true;
              user = "pgattic";
              openDefaultPorts = true;
              dataDir = "/home/pgattic";
            };
            udisks2.enable = true; # For Calibre to access plugged-in devices
            mullvad-vpn.enable = true;
          };
          system.stateVersion = "25.05";
        })

        config.flake.modules.nixos.base
        # config.flake.modules.nixos.git
        config.flake.modules.nixos.neovim
        config.flake.modules.nixos.nushell
        config.flake.modules.nixos.user

        config.flake.modules.nixos.desktop
        config.flake.modules.nixos.niri
        # config.flake.modules.nixos.noctalia
        config.flake.modules.nixos.portals
        config.flake.modules.nixos.stylix

        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            users.${config.my.user.name} = {
              imports = [
                config.flake.modules.homeManager.user
                config.flake.modules.homeManager.base
                config.flake.modules.homeManager.git
                config.flake.modules.homeManager.neovim
                config.flake.modules.homeManager.nushell
                config.flake.modules.homeManager.desktop
                config.flake.modules.homeManager.niri
                config.flake.modules.homeManager.noctalia
                config.flake.modules.homeManager.portals
                config.flake.modules.homeManager.stylix
                ({ pkgs, ... }: {
                  home.packages = with pkgs; [
                    zed-editor
                    mcpelauncher-ui-qt
                    discord
                    obsidian
                    slack
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

                  programs.helix.enable = true;
                })
              ];
            };
          };
        }
      ];
    };
  };
}
