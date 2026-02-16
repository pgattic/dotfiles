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

    homeModules.user = { osConfig, ... }: {
      home.username = osConfig.my.user.name;
      home.homeDirectory = osConfig.my.user.home_dir;
    };
  };
}

