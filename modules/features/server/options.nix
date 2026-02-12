{
  flake.nixosModules.server-options = { lib, ... }: {
    options.my.server = with lib; {
      domain = mkOption {
        type = types.str;
        default = "corlessfamily.net";
        description = "Domain name used for reverse proxies";
      };
      storage_path = mkOption {
        type = types.path;
        default = "/tank";
        description = "Path to main data storage";
      };
      movie_path = mkOption {
        type = types.path;
        default = "/tank/media/movies";
        description = "Location to store/retrieve movies";
      };
      music_path = mkOption {
        type = types.path;
        default = "/tank/media/music";
        description = "Location to store/retrieve music";
      };
      audiobook_path = mkOption {
        type = types.path;
        default = "/tank/media/audiobooks";
        description = "Location to store/retrieve audiobooks";
      };
      appdata_path = mkOption {
        type = types.path;
        default = "/tank/appdata";
        description = "Location for appdata such as databases";
      };
      store_path = mkOption {
        type = types.path;
        default = "/tank/store";
        description = "Location for store";
      };
    };
  };
}

