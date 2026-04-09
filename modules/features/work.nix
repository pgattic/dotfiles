{
  flake.nixosModules.work = { config, lib, pkgs, ... }: {
    environment.systemPackages = [
      pkgs.slack
    ];
    # For doing terminals through USB
    users.users.${config.my.user.name}.extraGroups = lib.mkAfter [
      "dialout"
    ];
  };
}

