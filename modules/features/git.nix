let
  hmModule = { config, ... }: {
    programs = {
      git = {
        enable = true;
        settings = {
          user.name = config.my.user.name;
          user.email = config.my.user.email;
          color.ui = "auto";
          init.defaultBranch = "master";
        };
      };
      lazygit.enable = true;
      jujutsu = {
        enable = true;
        settings = {
          user.name = config.my.user.name;
          user.email = config.my.user.email;
          ui = {
            default-command = [ "log" "--reversed" ];
            paginate = "never";
          };
        };
      };
      jjui = {
        enable = true;
      };
    };
  };
in {
  flake = {
    nixosModules.git = { config, ... }: {
      home-manager.users.${config.my.user.name}.imports = [ hmModule ];
    };

    homeModules.git = hmModule;
  };
}

