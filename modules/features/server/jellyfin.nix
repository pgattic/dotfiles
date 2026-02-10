{
  flake.nixosModules.jellyfin = { pkgs, ... }: {
    # Help transcode movies faster
    hardware.graphics.enable = true;
    hardware.graphics.extraPackages = with pkgs; [ intel-media-driver ]; # for newer Intel

    services.jellyfin.enable = true;

    services.nginx.virtualHosts."cinema.corlessfamily.net" = {
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
  };
}

