{
  flake = {
    nixosModules.neovim = { ... }: {
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

