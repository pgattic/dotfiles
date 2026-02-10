{ lib, ... }: {
  flake.nixosModules.user = { config, pkgs, ... }: {
    users.users.${config.my.user.name} = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
      description = config.my.user.description;
      shell = pkgs.nushell;
    };
  };

  flake.homeModules.user = { osConfig, ... }: {
    home.username = lib.mkDefault osConfig.my.user.name;
    home.homeDirectory = lib.mkDefault osConfig.my.user.home_dir;
    home.stateVersion = lib.mkDefault "25.05";
  };
}

