{ config, lib, ... }: {
  config = {
    flake.modules.homeManager.git = { pkgs, ... }: {
      home.packages = with pkgs; [
        lazygit
      ];

      programs = {
        git = {
          enable = true;
          settings = {
            user.name = config.my.user.name;
            user.email = "pgattic@gmail.com";
            color.ui = "auto";
            init.defaultBranch = "master";
          };
        };
      };
    };
  };
}

