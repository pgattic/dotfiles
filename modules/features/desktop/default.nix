{ config, ... }: {
  flake = {
    nixosModules.desktop-default = {
      imports = [
        config.flake.nixosModules.desktop-base
        config.flake.nixosModules.niri
        config.flake.nixosModules.noctalia
        config.flake.nixosModules.portals
        config.flake.nixosModules.stylix
      ];
    };
    homeModules.desktop-default = {
      imports = [
        config.flake.homeModules.desktop-base
        config.flake.homeModules.niri
        config.flake.homeModules.noctalia
        config.flake.homeModules.portals
        config.flake.homeModules.stylix
      ];
    };
  };
}

