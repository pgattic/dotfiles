inputs: {
  flake = {
    nixosModules.user = { config, pkgs, ... }: {
      home-manager.users.${config.my.user.name}.imports = [
        inputs.config.flake.homeModules.user
      ];
      users.users.${config.my.user.name} = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" ];
        description = config.my.user.description;
        shell = pkgs.nushell;
      };
    };

    homeModules.user = { config, ... }: {
      home.username = config.my.user.name;
      home.homeDirectory = config.my.user.home_dir;
    };
  };
}

