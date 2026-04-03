let
  hmModule = { pkgs, ... }: {
    home.packages = with pkgs; [
      slack
    ];
  };
in {
  flake = {
    nixosModules.work = { config, lib, ... }: {
      home-manager.users.${config.my.user.name} = hmModule;
      # For doing terminals through USB
      users.users.${config.my.user.name}.extraGroups = lib.mkAfter [
        "dialout"
      ];
    };
    homeModules.work = hmModule;
  };
}

