{ config, inputs, ... }: {
  flake.nixosConfigurations.corlessfam = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_hardware.nix
      config.flake.nixosModules.options

      ({ pkgs, ... }: {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        networking.hostName = "corlessfam";

        # Used for any directories or services that Transmission would want to download files into
        # Be sure to run the following commands in *`bash`*, not in `nushell`
        # `sudo chown -R transmission:torrentaccess /srv/{torrents,jellyfin,audiobookshelf}`
        # `sudo chmod -R 775 /srv/{torrents,jellyfin,audiobookshelf}`
        # `sudo chmod 2775 /srv/{torrents,jellyfin,audiobookshelf}`
        users.groups.torrentaccess = {};
        users.users.jellyfin.extraGroups = [ "video" "render" "torrentaccess" ];
        # users.users.transmission.extraGroups = [ "torrentaccess" ];
        users.users.audiobookshelf.extraGroups = [ "torrentaccess" ];
        users.users.immich.extraGroups = [ "video" "render" ];

        services = {
          openssh = {
            enable = true;
            package = pkgs.openssh_hpn;
          };

          postgresql = {
            enable = true;
            ensureDatabases = [ "firefly-iii" ];
            ensureUsers = [
              { name = "firefly-iii"; ensureDBOwnership = true; }
            ];
          };

          transmission = {
            enable = false;
            # openFirewall = true; # optional, allows peer and web ports
            settings = {
              download-dir = "/srv/torrents/downloads";
              incomplete-dir = "/srv/torrents/incomplete";
              incomplete-dir-enabled = true;
              rpc-enabled = true;
              rpc-bind-address = "0.0.0.0"; # listen on all interfaces
              rpc-port = 9091;
              # rpc-whitelist-enabled = true;
              # rpc-whitelist = "127.0.0.1,192.168.*.*,10.*.*.*"; # restrict to LAN
              # umask = 2;                 # 002 (decimal) → files 664, dirs 775
            };
          };

          resolved.enable = false; # Avoid port-53 (DNS) conflicts (systemd-resolved)

          firefly-iii = {
            enable = true;
            enableNginx = true;
            virtualHost = "finances.corlessfamily.net";

            settings = {
              APP_ENV = "production";
              TZ = "America/Boise";
              APP_KEY_FILE = "/var/lib/firefly-iii/app.key";

              DB_CONNECTION = "pgsql";
              DB_HOST = "/run/postgresql";
              DB_PORT = 5432;
              DB_DATABASE = "firefly-iii";
              DB_USERNAME = "firefly-iii";

              # If we are ever behind some tunnel or proxy, uncomment this:
              # TRUSTED_PROXIES = "**";
            };
          };

          audiobookshelf = {
            enable = true;
            port = 3682;
          };

          karakeep = {
            enable = true;
            extraEnvironment = {
              PORT = "4296";
              DISABLE_SIGNUPS = "true";
            };
          };

          immich = {
            enable = true;
            host = "127.0.0.1";
            accelerationDevices = null;
            port = 2283;
          };

          microbin = {
            enable = true;
            settings = {
              MICROBIN_HIDE_FOOTER = true;
              MICROBIN_HIDE_LOGO = true;
              MICROBIN_PORT = 3456;
            };
          };

          nginx = {
            virtualHosts = {
              "corlessfamily.net" = {
                enableACME = true;
                forceSSL = true;
                serverAliases = [ "www.corlessfamily.net" ];
                root = "/srv/home/public";
              };
              "finances.corlessfamily.net" = {
                enableACME = true;
                forceSSL = true;
              };
              "library.corlessfamily.net" = {
                enableACME = true;
                forceSSL = true;
                locations."/" = {
                  proxyPass = "http://127.0.0.1:3682";
                  proxyWebsockets = true;
                  extraConfig = ''
                    proxy_redirect http:// $scheme://;
                  '';
                };
              };
              "photos.corlessfamily.net" = {
                enableACME = true;
                forceSSL = true;
                locations."/" = {
                  proxyPass = "http://127.0.0.1:2283";
                  proxyWebsockets = true;
                  recommendedProxySettings = true;
                  extraConfig = ''
                    client_max_body_size 50000M;
                    proxy_read_timeout   600s;
                    proxy_send_timeout   600s;
                    send_timeout         600s;
                  '';
                };
              };
              "paste.corlessfamily.net" = {
                enableACME = true;
                forceSSL = true;
                locations."/" = {
                  proxyPass = "http://127.0.0.1:3456";
                  proxyWebsockets = true;
                };
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

        # systemd.services.transmission = {
        #   serviceConfig = {
        #     BindPaths = [
        #       "/srv/torrents"
        #       "/srv/jellyfin"
        #       "/srv/jellyfin/movies"
        #       "/srv/jellyfin/music"
        #     ];
        #     ReadWritePaths = [
        #       "/srv/torrents"
        #       "/srv/jellyfin"
        #       "/srv/jellyfin/movies"
        #       "/srv/jellyfin/music"
        #     ];
        #     UMask = lib.mkForce "0002";
        #     SupplementaryGroups = [ "torrentaccess" ];
        #   };
        # };

        system.stateVersion = "25.05"; # Version originally installed
      })
      config.flake.nixosModules.default
      config.flake.nixosModules.dynamic-dns
      config.flake.nixosModules.nginx
      config.flake.nixosModules.luanti-server
      config.flake.nixosModules.jellyfin
      # config.flake.nixosModules.minecraft-bedrock-server
      (inputs: {
        home-manager.users.${inputs.config.my.user.name}.imports = [
          config.flake.homeModules.default
        ];
      })
    ];
  };
}

