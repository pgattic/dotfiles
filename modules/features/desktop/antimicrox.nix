{
  flake.nixosModules.antimicrox = { config, lib, pkgs, ... }: {
    boot.kernelModules = [ "uinput" ];
    users.users.${config.my.user.name}.extraGroups = lib.mkAfter [
      "input"
    ];
    hardware.uinput.enable = true;
    environment.systemPackages = [
      pkgs.antimicrox
    ];
  };
}

