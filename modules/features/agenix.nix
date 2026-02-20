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
          owner = "qbittorrent"; group = "qbittorrent"; mode = "0400";
        };
        namecheap-dns-env = {
          file = ../../secrets/namecheap-dns-env.age;
          owner = "root"; group = "root"; mode = "0400";
        };
        copyparty-pgattic = {
          file = ../../secrets/copyparty-pgattic.age;
          owner = "copyparty"; group = "copyparty"; mode = "0400";
        };
        romm-auth-secret-key = {
          file = ../../secrets/romm-auth-secret-key.age;
          owner = "root"; group = "root"; mode = "0400";
        };
        romm-db-password = {
          file = ../../secrets/romm-db-password.age;
          owner = "root"; group = "root"; mode = "0400";
        };
        romm-mariadb-root-password = {
          file = ../../secrets/romm-mariadb-root-password.age;
          owner = "root"; group = "root"; mode = "0400";
        };
      };
    };
    homeModules.agenix = hmModule;
  };
}

