{ lib, ... }: let
  myOptions = with lib; {
    user = {
      name = mkOption {
        type = types.str;
        default = "pgattic";
        description = "Primary username";
      };
      description = mkOption {
        type = types.str;
        default = "Preston Corless";
        description = "Primary user's full name";
      };
    };
    server = {
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
  hmModule = { lib, osConfig ? null, ... }: let
    osMy = if (osConfig != null && lib.hasAttr "my" osConfig) then osConfig.my else {};
  in {
    options.my = myOptions;
    config.my = lib.mkDefault osMy;
  };
in {
  flake = {
    nixosModules.options = { config, ... }: {
      options.my = myOptions;
      config = {
        home-manager.users.${config.my.user.name} = hmModule;
      };
    };
    homeModules.options = hmModule;
  };
}

