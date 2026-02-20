let port = 3682; in {
  flake.nixosModules.audiobookshelf = { config, ... }: {
    services.audiobookshelf = {
      enable = true;
      port = port;
    };
    users.users.audiobookshelf.extraGroups = [ "media" ];

    services.nginx.virtualHosts."library.${config.my.server.domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString port}";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_redirect http:// $scheme://;
        '';
      };
    };
  };
}

