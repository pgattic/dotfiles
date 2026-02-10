{
  flake.nixosModules.options = { lib, ... }: {
    options.my = with lib; {
      user = {
        name = mkOption {
          type = types.str;
          default = "pgattic";
          description = "Primary username (shared between NixOS and Home Manager)";
        };
        description = mkOption {
          type = types.str;
          default = "Preston Corless";
          description = "Primary user's full name";
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
  };
}

