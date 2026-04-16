{ inputs, withSystem, ... }: let
  builderAuthorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN+tQ11EwCLxsnFls30h6ht7mEOAJ+JapnD61tzu/urS pgattic@gmail.com" # t480
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB0Qx8iBekJ07LRxUsDNm0bcSkilw7xX51LYrzz6F4xx pgattic@gmail.com" # mbair
  ];
in {
  flake.nixosConfigurations.corlessfam = withSystem "x86_64-linux" ({ pkgs, self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      inputs.self.nixosModules.options
      inputs.self.nixosModules.default
      inputs.self.nixosModules.agenix
      inputs.self.nixosModules.dynamic-dns
      inputs.self.nixosModules.nginx
      inputs.self.nixosModules.luanti-server
      inputs.self.nixosModules.jellyfin
      inputs.self.nixosModules.immich
      inputs.self.nixosModules.firefly
      inputs.self.nixosModules.audiobookshelf
      inputs.self.nixosModules.copyparty
      inputs.self.nixosModules.qbittorrent
      # inputs.self.nixosModules.romm
      inputs.self.nixosModules.cookbook

      ({ lib, pkgs, ... }: {
        boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
        boot.supportedFilesystems = [ "zfs" ];
        boot.zfs.extraPools = [ "tank" ]; # Automatic mounting
        services.zfs.autoScrub.enable = true;

        networking.hostId = "6e005e0f"; # head -c 8 /etc/machine-id
        networking.hostName = "corlessfam";
        system.stateVersion = "25.05";

        nix.settings = {
          max-jobs = lib.mkDefault 4;
          trusted-users = lib.mkAfter [ "nixbuilder" ];
        };

        users = {
          groups.nixbuilder = {};
          users = {
            nixbuilder = {
              isSystemUser = true;
              group = "nixbuilder";
              home = "/var/lib/nixbuilder";
              createHome = true;
              shell = pkgs.bashInteractive;
              openssh.authorizedKeys.keys = builderAuthorizedKeys;
            };
            pgattic = {
              shell = (self'.packages.nushell-env.apply {
                extraPackages = [
                  self'.packages.neovim
                  self'.packages.git
                  pkgs.lazygit
                ];
              }).wrapper;
              openssh.authorizedKeys.keys = builderAuthorizedKeys;
            };
          };
        };

        environment.systemPackages = [
          pkgs.smartmontools # Used for hard drive SMART tests (`sudo smartctl -x /dev/sdX`)
        ];

        services = {
          openssh.enable = true;
          smartd.enable = true; # added alongside `smartmontools` package

          karakeep = {
            enable = true;
            extraEnvironment = {
              PORT = "4296";
              DISABLE_SIGNUPS = "true";
            };
          };

          nginx = {
            virtualHosts = {
              "corlessfamily.net" = {
                enableACME = true;
                forceSSL = true;
                serverAliases = [ "www.corlessfamily.net" ];
                root = "/tank/media/home/public";
              };
              "keep.corlessfamily.net" = {
                enableACME = true;
                forceSSL = true;
                locations."/" = {
                  proxyPass = "http://127.0.0.1:4296";
                  proxyWebsockets = true;
                };
              };
            };
          };
        };
      })
    ];
  });
}
