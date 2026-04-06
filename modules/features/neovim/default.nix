let
  nvimConfig = ./config;
  hmModule = {
    programs = {
      neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
      };
    };
    home.file.".config/nvim/init.lua".source = "${nvimConfig}/init.lua";
    home.file.".config/nvim/lua" = {
      source = "${nvimConfig}/lua";
      recursive = true;
    };
  };
in {
  flake = {
    nixosModules.neovim = { config, ... }: {
      home-manager.users.${config.my.user.name} = hmModule;
      environment.sessionVariables = {
        EDITOR = "nvim";
      };
    };
    homeModules.neovim = hmModule;
  };
}

