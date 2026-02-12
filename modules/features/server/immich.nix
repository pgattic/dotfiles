let port = 2283; in {
  flake.nixosModules.immich = { config, ... }: {
    services.immich = {
      enable = true;
      host = "127.0.0.1";
      accelerationDevices = null;
      port = port;
      settings = {
        newVersionCheck.enabled = false;
      };
      # mediaLocation = "/tank/store/immich";
    };
    services.nginx.virtualHosts."photos.${config.my.server.domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString port}";
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
}

