{
  flake.nixosModules.nginx = { ... }: {
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
    };
    networking.firewall = {
      allowedTCPPorts = [
        # 53 # DNS
        80 # HTTP
        443 # HTTPS
      ];
      allowedUDPPorts = [
        53
      ];
    };
  };
}

