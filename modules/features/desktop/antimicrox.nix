let
  hmModule = { pkgs, ... }: {
    home.packages = with pkgs; [
      antimicrox
    ];
  };
in {
  flake = {
    nixosModules.antimicrox = { lib, config, ... }: {
      home-manager.users.${config.my.user.name} = hmModule;

      boot.kernelModules = [ "uinput" ];
      users.users.${config.my.user.name}.extraGroups = lib.mkAfter [
        "input"
      ];
      hardware.uinput.enable = true;
    };
    homeModules.antimicrox = hmModule;
  };
}

