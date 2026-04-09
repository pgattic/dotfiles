{ config, ... }: {
  flake = {
    nixosModules.default = { ... }: {
      imports = [
        config.flake.nixosModules.base
        config.flake.nixosModules.networking
        config.flake.nixosModules.user
      ];
    };
    homeModules.default = { ... }: {
      imports = [
        config.flake.homeModules.base
        config.flake.homeModules.user
      ];
    };
  };
}

