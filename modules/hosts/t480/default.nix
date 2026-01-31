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
        boot.kernelModules = [ "uinput" ];

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

      config.flake.nixosModules.base
      config.flake.nixosModules.desktop
      config.flake.nixosModules.work

      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit inputs; };
          users.${config.my.user.name} = {
            imports = [
              config.flake.homeModules.base
              config.flake.homeModules.desktop
              config.flake.homeModules.work

              ({ pkgs, ... }: {
                home.packages = with pkgs; [
                  zed-editor
                  mcpelauncher-ui-qt
                  discord
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

                programs.helix.enable = true;
                programs.niri.settings.outputs."eDP-1".scale = 1.0;
              })
            ];
          };
        };
      }
    ];
  };
}
