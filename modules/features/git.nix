{ ... }: {
  flake = {
    nixosModules.git = { ... }: {};
    homeModules.git = { osConfig, pkgs, ... }: {
      home.packages = with pkgs; [
        lazygit
      ];

      programs = {
        git = {
          enable = true;
          settings = {
            user.name = osConfig.my.user.name;
            user.email = "pgattic@gmail.com";
            color.ui = "auto";
            init.defaultBranch = "master";
          };
        };
      };
    };
  };
}

