{ config, lib, pkgs, ... }:
let
  # localIP = "192.168.1.2";
  # localIP6 = "fe80::4ba3:e094:bffe:51a5";
in {
  imports = [
    ./hardware-configuration.nix
    ./dynamic-dns.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "corlessfam";
  networking.networkmanager.enable = true; # TODO: replace with systemd-networkd
  time.timeZone = "America/Boise";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Help transcode Jellyfin movies faster
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [ intel-media-driver ]; # for newer Intel

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

  users.users.pgattic = {
    isNormalUser = true;
    description = "Preston Corless";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
    shell = pkgs.nushell;
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    git
    nushell
    dufs
    zola
    fastfetch
    btop
    nh
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    configure = {
      customRC = ''
        set nu
        
        set expandtab
        set tabstop=2
        set softtabstop=2
        set shiftwidth=2
        
        set termguicolors
        set smartindent
        set scrolloff=4
        set colorcolumn="100"
      '';
    };
  };

  # sudo journalctl -u acme-corlessfamily.net.service
  security.acme = {
    acceptTerms = true;
    defaults.email = "pgattic@gmail.com";
    # validMinDays = 999; # Uncomment for one rebuild to force immediate renewal
  };

  services = {
    openssh.enable = true;

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

    # pihole-ftl = {
    #   enable = true;
    #   settings = { # Maps to TOML config
    #     dns = {
    #       hosts = [
    #         "${localIP} corlessfamily.net"
    #         "${localIP} www.corlessfamily.net"
    #         "${localIP} files.corlessfamily.net"
    #         "${localIP} cinema.corlessfamily.net"
    #         "${localIP} finances.corlessfamily.net"
    #         "${localIP} cookbook.corlessfamily.net"
    #         "${localIP} library.corlessfamily.net"
    #
    #         "${localIP6} corlessfamily.net"
    #         "${localIP6} www.corlessfamily.net"
    #         "${localIP6} files.corlessfamily.net"
    #         "${localIP6} cinema.corlessfamily.net"
    #         "${localIP6} finances.corlessfamily.net"
    #         "${localIP6} cookbook.corlessfamily.net"
    #         "${localIP6} library.corlessfamily.net"
    #       ];
    #       upstreams = [
    #         "1.1.1.1" # Cloudflare ipv4 (DNSSEC)
    #         "2606:4700:4700::1111" # Cloudflare ipv6 (DNSSEC)
    #       ];
    #     };
    #   };
    # };
    #
    # pihole-web = {
    #   enable = true;
    #   ports = [ "8081" ];
    # };

    resolved.enable = false; # Avoid port-53 (DNS) conflicts (systemd-resolved)

    minetest-server = {
      enable = true;
      gameId = "mineclonia"; # Minecraft ripoff
      world = "/var/lib/minetest/.minetest/worlds/mcl_world";
      config = {
        name = "pgattic"; # admin player username
        server_name = "Corless Family Mineclonia Server";
        server_description = "Live, Laugh, Love <3";
        server_announce = false; # Don't report to main server list
        motd = "Live, Laugh, Love <3";
        max_users = 15;
        difficulty = "easy";
        bind_address = "0.0.0.0";
        movement_speed_walk = "5.612"; # Minecraft sprint speed
        enable_damage = true;
        creative_mode = false;
      };
    };

    # copyparty = {
    #   enable = true;
    #   settings = {
    #     i = "127.0.0.1";
    #     p = [ 3210 ];
    #     no-reload = true;
    #     # ignored-flag = false;
    #   };
    #   accounts = {
    #     pgattic.passwordFile = "/srv/copyparty/passwd/pgattic";
    #     skylar.passwordFile = "/srv/copyparty/passwd/skylar";
    #   };
    #   volumes = {
    #     "/family" = {
    #       path = "/srv/copyparty/family";
    #       access = {
    #         rwd = [ "pgattic" "skylar" ];
    #       };
    #     };
    #     "/pgattic" = {
    #       path = "/srv/copyparty/pgattic";
    #       access = {
    #         rwd = [ "pgattic" ];
    #       };
    #     };
    #     "/skylar" = {
    #       path = "/srv/copyparty/skylar";
    #       access = {
    #         rwd = [ "skylar" ];
    #       };
    #     };
    #   };
    # };

    jellyfin = {
      enable = true;
    };

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

    # tandoor-recipes = {
    #   enable = true;
    #   address = "127.0.0.1";
    #   port = 3421;
    # };

    audiobookshelf.enable = true;

    immich = {
      enable = true;
      host = "127.0.0.1";
      accelerationDevices = null;
      port = 2283;
    };

    nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts = {
        "corlessfamily.net" = {
          enableACME = true;
          forceSSL = true;
      
          serverAliases = [ "www.corlessfamily.net" ];
          root = "/srv/home/public";
        };
        "cinema.corlessfamily.net" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:8096";
            proxyWebsockets = true;
            # Jellyfin-friendly extras (help streaming, seeks, large payloads)
            extraConfig = ''
              proxy_buffering off;
              client_max_body_size 0;
              proxy_read_timeout 3600s;
              proxy_send_timeout 3600s;
              send_timeout 3600s;
              proxy_set_header Range $http_range;
              proxy_set_header If-Range $http_if_range;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection $http_connection;
            '';
          };
        };
        "finances.corlessfamily.net" = {
          enableACME = true;
          forceSSL = true;
        };
        "cookbook.corlessfamily.net" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:3421";
            proxyWebsockets = true;
          };
        };
        "library.corlessfamily.net" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${builtins.toString config.services.audiobookshelf.port}";
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
      };
    };
  };

  systemd.services.minetest-server.environment.MINETEST_GAME_PATH = pkgs.mineclonia-game;

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

  # virtualisation.podman.enable = true;
  # The oci-containers module manages the container as a systemd service
  # virtualisation.oci-containers = {
  #   backend = "podman";
  #
  #   containers.bedrock = { # Minecraft Bedrock Server
  #     # podman logs -f bedrock
  #     # podman exec -it bedrock /bin/bash
  #     # # The image includes a helper to send server commands:
  #     # podman exec bedrock send-command "op \"YourGamertag\""
  #     image = "docker.io/itzg/minecraft-bedrock-server:latest";
  #     autoStart = true;
  #     volumes = [ "/var/lib/bedrock:/data" ]; # Location where world is stored
  #     ports = [ "19132:19132/udp" ];
  #
  #     environment = {
  #       VERSION = "1.21.60.10";
  #       EULA = "TRUE";
  #       TZ = "America/Boise";
  #
  #       SERVER_NAME = "Corless Family Server";
  #       GAMEMODE = "survival";
  #       DIFFICULTY = "easy";
  #       ONLINE_MODE = "true"; # Xbox Account requirement
  #       LEVEL_NAME = "world";
  #       ALLOW_LIST = "false"; # Whitelist
  #       # ALLOW_LIST_USERS = "Player1:1234567890,Player2:0987654321";
  #       # LEVEL_SEED = "12345";
  #     };
  #
  #     extraOptions = [
  #       "--dns=1.1.1.1"
  #       # OPTIONAL: if you have a local search domain
  #       # "--dns-search=lan"
  #     ];
  #   };
  # };

  # # Create/persist the data dir with sane perms
  # users.groups.bedrock = { };
  # users.users.bedrock = { isSystemUser = true; group = "bedrock"; home = "/var/lib/bedrock"; };
  # systemd.tmpfiles.rules = [ "d /var/lib/bedrock 0750 bedrock bedrock -" ];

  environment.sessionVariables = {
    NH_OS_FLAKE = "/home/pgattic/dotfiles";
  };

  networking.firewall = {
    allowedTCPPorts = [
      # 53 # DNS
      80 # HTTP
      443 # HTTPS
      # 8081 # Pihole (http, LAN-only)
      30000 # Luanti/Minetest
      # 9091 51413 # Transmission (BitTorrent)
    ];
    allowedUDPPorts = [
      53
      30000 # Luanti/Minetest
      # 19132 # Minecraft Bedrock
      # 51413 # Transmission (BitTorrent)
    ];
  };

  system.stateVersion = "25.05"; # Version originally installed
}


