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
      email = mkOption {
        type = types.str;
        default = "pgattic@gmail.com";
        description = "Primary user's email";
      };
      home_dir = mkOption {
        type = types.str;
        default = "/home/pgattic";
        description = "Primary user's home directory";
      };
    };
    desktop = {
      touch_options = mkEnableOption "touch-related options like extra buttons, slightly bigger UI, etc.";
      corner_radius = mkOption {
        type = types.float;
        default = 8.0;
        description = "Corner radius of Desktop elements";
      };
      opacity = mkOption {
        type = types.float;
        default = 0.85;
        description = "Opacity of certain UI elements (terminals, statusbar)";
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
    # If osConfig is null (which happens in some eval stages), 
    # or if 'my' doesn't exist, we fall back to an empty set.
    osMy = if (osConfig != null && lib.hasAttr "my" osConfig) then osConfig.my else {};
  in {
    options.my = myOptions;
    config = {
      # We use mkOptionDefault. This has a lower priority than a normal 
      # assignment, so if you set 'my.user.name' in your HM config, 
      # it will override the value coming from NixOS.
      my = lib.mkOptionDefault osMy;
    };
  };
in {
  flake = {
    nixosModules.options = { config, ... }: {
      options.my = myOptions;
      config = {
        home-manager.users.${config.my.user.name}.imports = [ hmModule ];
      };
    };
    homeModules.options = hmModule;
  };
}

