{
  flake = {
    nixosModules.neovim = { ... }: {
      environment.sessionVariables = {
        EDITOR = "nvim";
      };
    };

    homeModules.neovim = { ... }: {
      stylix.targets.neovim.enable = false;
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

