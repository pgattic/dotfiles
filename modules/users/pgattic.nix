{ config, lib, inputs, ... }:
let
  username = "pgattic";
in {
  options = {
    my.user.name = lib.mkOption {
      type = lib.types.str;
      description = "Primary username for this flake";
    };
    my.user.home_dir = lib.mkOption {
      type = lib.types.str;
      description = "Home directory for this flake's main user";
    };
  };

  config = {

    my.user.name = username;
    my.user.home_dir = "/home/${username}";

    flake.nixosModules.user = { pkgs, ... }: {
      users.users.${config.my.user.name} = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" ];
        description = "Preston Corless";
        shell = pkgs.nushell;
      };
    };

    flake.homeModules.user = { ... }: {
      home.username = lib.mkDefault config.my.user.name;
      home.homeDirectory = lib.mkDefault config.my.user.home_dir;
      home.stateVersion = lib.mkDefault "25.05";
    };
  };
}

