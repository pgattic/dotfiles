{ config, ... }: {
  flake = {
    nixosModules.default = { ... }: {
      imports = [
        config.flake.nixosModules.base
        config.flake.nixosModules.git
        config.flake.nixosModules.neovim
        config.flake.nixosModules.networking
        config.flake.nixosModules.nushell
        config.flake.nixosModules.user
      ];
    };

    homeModules.default = { ... }: {
      imports = [
        config.flake.homeModules.base
        config.flake.homeModules.git
        config.flake.homeModules.neovim
        config.flake.homeModules.networking
        config.flake.homeModules.nushell
        config.flake.homeModules.user
      ];
    };
  };
}

