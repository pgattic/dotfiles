{
  flake = {
    nixosModules.neovim = { pkgs, ... }: {
      environment.sessionVariables = {
        EDITOR = "nvim";
      };
    };

    homeModules.neovim = { pkgs, ... }: {
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

