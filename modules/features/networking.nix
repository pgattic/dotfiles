{
  flake = {
    nixosModules.networking = { ... }: {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = false;
        settings.General.Experimental = true;
      };
      networking.networkmanager.enable = true;
    };
    homeModules.networking = { ... }: {};
  };
}

