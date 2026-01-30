{ config, lib, ... }: {
  config = {
    flake.modules.nixos.neovim = { pkgs, ... }: {
      environment.sessionVariables = {
        EDITOR = "nvim";
      };
    };

    flake.modules.homeManager.neovim = { pkgs, ... }: {
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

