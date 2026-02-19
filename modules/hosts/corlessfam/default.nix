{ config, inputs, ... }: {
  flake.nixosConfigurations.corlessfam = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_hardware.nix
      config.flake.nixosModules.options
      config.flake.nixosModules.default
      config.flake.nixosModules.agenix
      config.flake.nixosModules.dynamic-dns
      config.flake.nixosModules.nginx
      config.flake.nixosModules.luanti-server
      config.flake.nixosModules.jellyfin
      config.flake.nixosModules.immich
      config.flake.nixosModules.firefly
      config.flake.nixosModules.audiobookshelf
      config.flake.nixosModules.copyparty
      config.flake.nixosModules.qbittorrent

      {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        boot.supportedFilesystems = [ "zfs" ];
        boot.zfs.extraPools = [ "tank" ]; # Automatic mounting
        services.zfs.autoScrub.enable = true;

        networking.hostId = "6e005e0f"; # head -c 8 /etc/machine-id
        networking.hostName = "corlessfam";

        users.users.pgattic.openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN+tQ11EwCLxsnFls30h6ht7mEOAJ+JapnD61tzu/urS pgattic@gmail.com"
        ];

        services = {
          openssh.enable = true;

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

        system.stateVersion = "25.05"; # Version originally installed
      }
    ];
  };
}

