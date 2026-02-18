{ inputs, ... }: let
  hmModule = { pkgs, ... }: {
    home.packages = with pkgs; [
      slack
    ];
  };
in { # Stuff I need installed on my system for work
  flake = {
    nixosModules.work = { config, lib, ... }: {
      home-manager.users.${config.my.user.name}.imports = [ hmModule ];
      # Some stuff for doing terminals through USB
      boot.kernelModules = [ "uinput" ];
      users.users.${config.my.user.name}.extraGroups = lib.mkAfter [
        "dialout"
      ];
      hardware.uinput.enable = true;
    };

    homeModules.work = hmModule;
  };
}

