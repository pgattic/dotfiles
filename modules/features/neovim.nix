let
  hmModule = {
    programs = {
      neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
      };
    };
  };
in {
  flake = {
    nixosModules.neovim = { config, ... }: {
      home-manager.users.${config.my.user.name}.imports = [ hmModule ];
      environment.sessionVariables = {
        EDITOR = "nvim";
      };
    };

    homeModules.neovim = hmModule;
  };
}

