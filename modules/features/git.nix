let
  hmModule = { config, ... }: {
    programs = {
      git = {
        enable = true;
        settings = {
          user = { inherit (config.my.user) name email; };
          color.ui = "auto";
          init.defaultBranch = "master";
        };
      };
      lazygit.enable = true;
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

