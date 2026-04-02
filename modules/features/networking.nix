{
  flake = {
    nixosModules.networking = { config, lib, ... }: {
      hardware.bluetooth = {
        enable = lib.mkDefault true;
        powerOnBoot = false;
        settings.General.Experimental = true;
      };
      networking.networkmanager.enable = lib.mkDefault true;
      users.users.${config.my.user.name}.extraGroups = lib.mkAfter [ "networkmanager" ];

      # EDNS is broken on our wifi router.
      # The host-side solution is either disable EDNS, or use a separate DNS server. I went with the latter.
      # TODO: Remove these two lines when I get a new router
      networking.networkmanager.dns = "none";
      networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
    };
  };
}

