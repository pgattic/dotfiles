inputs: let
  options = with inputs.lib; {
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
  };
in {
  flake = {
    nixosModules.options = { config, ... }: {
      options.my = options;
      config = {
        home-manager.users.${config.my.user.name}.imports = [
          inputs.config.flake.homeModules.options
        ];
      };
    };
    homeModules.options = { lib, osConfig ? null, ... }: {
      options.my = options;
      config.my = lib.mkIf (osConfig != null && osConfig ? my) osConfig.my;
    };
  };
}

