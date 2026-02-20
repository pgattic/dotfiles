let
  port = 3365;
  appdata = "/tank/appdata/romm";
  romsDir = "/tank/media/roms";
in {
  flake.nixosModules.romm = { config, pkgs, ... }: let
    cfg = config.my.server;
    sec = config.age.secrets;
  in {
    # --- dirs on ZFS datasets ---
    systemd.tmpfiles.rules = [
      "d ${appdata} 0750 root root - -"
      "d ${appdata}/db 0750 root root - -"
      "d ${appdata}/resources 0750 root root - -"
      "d ${appdata}/redis-data 0750 root root - -"
      "d ${appdata}/assets 0750 root root - -"
      "d ${appdata}/config 0750 root root - -"
    ];

    # --- container runtime ---
    virtualisation.podman = {
      enable = true;
      autoPrune.enable = true;
    };
    virtualisation.oci-containers.backend = "podman";

    # Create a dedicated network so DB isn't exposed.
    systemd.services.podman-create-romm-network = {
      wantedBy = [ "multi-user.target" ];
      before = [ "podman-romm-db.service" "podman-romm.service" ];
      serviceConfig.Type = "oneshot";
      script = ''
        ${pkgs.podman}/bin/podman network exists romm || ${pkgs.podman}/bin/podman network create romm
      '';
    };

    virtualisation.oci-containers.containers = {
      romm-db = {
        image = "docker.io/library/mariadb:latest";
        autoStart = true;
        extraOptions = [
          "--network=romm"
          "--network-alias=romm-db"
        ];
        volumes = [
          "/run/agenix:/run/agenix:ro" # Give container access to secrets
          "${appdata}/db:/var/lib/mysql"
        ];
        environment = {
          MARIADB_DATABASE = "romm";
          MARIADB_USER = "romm-user";
          MARIADB_PASSWORD_FILE = sec.romm-db-password.path;
          MARIADB_ROOT_PASSWORD_FILE = sec.romm-mariadb-root-password.path;
        };
      };

      romm = {
        image = "docker.io/rommapp/romm:latest";
        autoStart = true;
        dependsOn = [ "romm-db" ];
        extraOptions = [
          "--network=romm"
        ];

        # Keep it local; put nginx in front for HTTPS.
        ports = [
          "127.0.0.1:${builtins.toString port}:${builtins.toString port}"
        ];

        volumes = [
          "/run/agenix:/run/agenix:ro"
          "${appdata}/resources:/romm/resources"
          "${appdata}/redis-data:/redis-data"
          "${appdata}/assets:/romm/assets"
          "${appdata}/config:/romm/config"

          # Read-only access to rom library
          "${romsDir}:/romm/library/roms:ro"
        ];

        environment = {
          TZ = "America/Boise";
          ROMM_PORT = builtins.toString port;

          DB_HOST = "romm-db";
          DB_NAME = "romm";
          DB_USER = "romm-user";

          # RomM supports *_FILE for secrets
          DB_PASSWD_FILE = sec.romm-db-password.path;
          ROMM_AUTH_SECRET_KEY_FILE = sec.romm-auth-secret-key.path;

          # Optional providers (examples)
          # SCREENSCRAPER_USER_FILE = sec.screenscraper-user.path;
          # SCREENSCRAPER_PASSWORD_FILE = sec.screenscraper-password.path;
          # STEAMGRIDDB_API_KEY_FILE = sec.steamgriddb-api-key.path;
        };
      };
    };

    # --- optional: nginx reverse proxy ---
    services.nginx.virtualHosts."roms.${cfg.domain}" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        extraConfig = ''
          client_max_body_size 0;
        '';
      };
    };
  };
}

