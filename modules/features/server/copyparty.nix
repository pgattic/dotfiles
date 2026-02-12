{ inputs, ... }: let port = 3683; in {
  flake.nixosModules.copyparty = { config, ... }: {
    imports = [
      inputs.copyparty.nixosModules.default
    ];

    nixpkgs.overlays = [ inputs.copyparty.overlays.default ];

    services.copyparty = {
      enable = true;
      settings = {
        i = "0.0.0.0";
        p = [ port ];
        xff-hdr = "x-forwarded-for";
        xff-src = [ "127.0.0.1" "::1" ];
        rproxy  = 1;
      };
      accounts = {
        pgattic.passwordFile = "/tank/secrets/copyparty/pgattic";
      };
      volumes = {
        "/pgattic" = {
          path = "/tank/store/pgattic";
          access = {
            rw = [ "pgattic" ];
          };
        };
      };
    };

    services.nginx.virtualHosts."files.${config.my.server.domain}" = {
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

