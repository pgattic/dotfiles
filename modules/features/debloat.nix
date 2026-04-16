{ lib, ... }: {
  flake.nixosModules.debloat = {
    # Perlless https://github.com/NixOS/nixpkgs/blob/0260f927b7c1578b5c7cdefd7db7b660565cd362/nixos/modules/profiles/perlless.nix
    system.disableInstallerTools = true; # remove generate, install, enter, option, version, build-vms, firewall
    system.tools.nixos-rebuild.enable = true; # but keep rebuild

    # Remove unnecessary packages
    environment.defaultPackages = lib.mkForce [ ];
    programs.nano.enable = false;
    services.speechd.enable = false;

    documentation = {
      enable = false;
      doc.enable = false;
      info.enable = false;
      nixos.enable = false;
    };

    # system.forbiddenDependenciesRegexes = [ "perl" ];

    # If /etc is read-only, we need to provide the machine-id file as a mount point for systemd.
    # https://www.freedesktop.org/software/systemd/man/256/machine-id.html#Initialization
    # environment.etc."machine-id".text = "";
    # system.etc.overlay.enable = true; # multiple errors for now

    systemd.enableStrictShellChecks = true;
    services.dbus.implementation = "broker";

    systemd.services.NetworkManager-wait-online.enable = false; # Don't require internet connection on boot
  };
}

