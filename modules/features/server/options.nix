{
  flake.nixosModules.server-options = { lib, ... }: {
    options.my.server = with lib; {
      domain = mkOption {
        type = types.str;
        default = "corlessfamily.net";
        description = "Domain name used for reverse proxies";
      };
      paths = {
        storage = mkOption {
          type = types.path;
          default = "/tank";
          description = "Path to main data storage";
        };
        media = mkOption {
          type = types.path;
          default = "/tank/media";
          description = "Location for media such as movies and books";
        };
        appdata = mkOption {
          type = types.path;
          default = "/tank/appdata";
          description = "Location for appdata such as databases";
        };
        store = mkOption {
          type = types.path;
          default = "/tank/store";
          description = "Location for store";
        };
        secrets = mkOption {
          type = types.path;
          default = "/tank/secrets";
          description = "Location for secrets like password files";
        };
      };
    };
  };
}

