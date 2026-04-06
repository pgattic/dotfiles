let
  hmModule = { config, ... }: {
    home.username = config.my.user.name;
    home.homeDirectory = "/home/${config.my.user.name}";
  };
in {
  flake = {
    nixosModules.user = { config, pkgs, ... }: {
      home-manager.users.${config.my.user.name} = hmModule;
      users.users.${config.my.user.name} = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        description = config.my.user.description;
      };
    };
    homeModules.user = hmModule;
  };
}

