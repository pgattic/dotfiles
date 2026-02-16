inputs: {
  flake = {
    nixosModules.git = { config, ... }: {
      home-manager.users.${config.my.user.name}.imports = [
        inputs.config.flake.homeModules.git
      ];
    };

    homeModules.git = { osConfig, pkgs, ... }: {
      home.packages = with pkgs; [
        lazygit
      ];

      programs = {
        git = {
          enable = true;
          settings = {
            user.name = osConfig.my.user.name;
            user.email = osConfig.my.user.email;
            color.ui = "auto";
            init.defaultBranch = "master";
          };
        };
      };
    };
  };
}

