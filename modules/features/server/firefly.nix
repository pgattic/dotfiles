{
  flake.nixosModules.firefly = { config, ... }: {
    services.postgresql = {
      enable = true;
      ensureDatabases = [ "firefly-iii" ];
      ensureUsers = [
        { name = "firefly-iii"; ensureDBOwnership = true; }
      ];
    };

    services.firefly-iii = {
      enable = true;
      enableNginx = true;
      virtualHost = "finances.${config.my.server.domain}";

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
    services.nginx.virtualHosts."finances.${config.my.server.domain}" = {
      enableACME = true;
      forceSSL = true;
    };
  };
}

