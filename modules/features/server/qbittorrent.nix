{
  flake.nixosModules.qbittorrent = { config, pkgs, ... }: {
    services.qbittorrent = {
      enable = true;
      webuiPort = 6969;
      openFirewall = true;
    };
  };
}

