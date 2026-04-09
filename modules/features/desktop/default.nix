{ config, ... }: {
  flake = {
    nixosModules.desktop-default = {
      imports = [
        config.flake.nixosModules.desktop-base
        config.flake.nixosModules.portals
        config.flake.nixosModules.stylix
      ];
    };
    homeModules.desktop-default = { ... }: {
      imports = [
        config.flake.homeModules.desktop-base
        config.flake.homeModules.stylix
      ];
    };
  };
}

