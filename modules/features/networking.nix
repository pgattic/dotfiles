inputs: {
  flake = {
    nixosModules.networking = { config, ... }: {
      home-manager.users.${config.my.user.name}.imports = [
        inputs.config.flake.homeModules.networking
      ];
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = false;
        settings.General.Experimental = true;
      };
      networking.networkmanager.enable = true;

      # EDNS is broken on our wifi router.
      # The host-side solution is either disable EDNS, or use a separate DNS server. I went with the latter.
      # TODO: Remove these two lines when I get a new router
      networking.networkmanager.dns = "none";
      networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
    };
    homeModules.networking = { ... }: {};
  };
}

