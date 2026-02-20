let port = 8096; in {
  flake.nixosModules.jellyfin = { config, pkgs, ... }: let cfg = config.my.server; in {
    # Help transcode movies faster
    hardware.graphics.enable = true;
    hardware.graphics.extraPackages = with pkgs; [ intel-media-driver ]; # for newer Intel

    services.jellyfin.enable = true;
    users.users.jellyfin.extraGroups = [ "media" ];

    services.nginx.virtualHosts."cinema.${cfg.domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString port}";
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
  };
}

