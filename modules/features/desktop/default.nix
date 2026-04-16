{ config, ... }: {
  flake = {
    nixosModules.desktop-default = {
      imports = [
        config.flake.nixosModules.desktop-base
        config.flake.nixosModules.portals
      ];
    };
    homeModules.desktop-default = { ... }: {
      imports = [
        config.flake.homeModules.desktop-base
      ];
    };
  };
}

