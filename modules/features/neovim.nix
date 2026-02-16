inputs: {
  flake = {
    nixosModules.neovim = { config, ... }: {
      home-manager.users.${config.my.user.name}.imports = [
        inputs.config.flake.homeModules.neovim
      ];
      environment.sessionVariables = {
        EDITOR = "nvim";
      };
    };

    homeModules.neovim = { ... }: {
      programs = {
        neovim = {
          enable = true;
          viAlias = true;
          vimAlias = true;
          vimdiffAlias = true;
        };
      };
    };
  };
}

