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
  };
}

