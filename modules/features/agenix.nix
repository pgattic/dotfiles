{ inputs, ... }: let
  hmModule = { pkgs, ... }: {
    imports = [
      inputs.agenix.homeManagerModules.default
    ];
    home.packages = [
      inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
in {
  flake = {
    nixosModules.agenix = { config, pkgs, ... }: {
      home-manager.users.${config.my.user.name}.imports = [ hmModule ];
      imports = [
        inputs.agenix.nixosModules.default
      ];
      age.secrets = {
        qbittorrent-pass = {
          file = ../../secrets/qbittorrent-pass.age;
          owner = "qbittorrent";
          group = "qbittorrent";
          mode = "0400";
        };
      };
    };
    homeModules.agenix = hmModule;
  };
}

