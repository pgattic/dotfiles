{ inputs, ... }: {
  flake.nixosModules.qbittorrent = { config, pkgs, lib, ... }: let
    cfg = config.my.server;
    webuiPort = 6969;
    peerPort = 51413;
    lanCidr = "192.168.1.0/24";
    defaultDir = "${cfg.paths.media}/default";

    qbUser = "qbittorrent";
    qbGroup = "qbittorrent";

    qbStateDir = "/var/lib/qBittorrent";
    qbConfDir = "${qbStateDir}/qBittorrent/config";
    qbConfPath = "${qbConfDir}/qBittorrent.conf";


    qbConfTemplate = pkgs.writeText "qBittorrent.conf.template" ''
      [LegalNotice]
      Accepted=true

      [BitTorrent]
      Session\DefaultSavePath=${defaultDir}
      Session\Interface=wg0
      Session\InterfaceName=wg0
      Session\InterfaceAddress=10.70.37.83
      Session\Port=${toString peerPort}
      Session\TempPathEnabled=true
      Session\TempPath=${defaultDir}

      [Preferences]
      WebUI\Username=${config.my.user.name}
      WebUI\Password_PBKDF2=@QB_WEBUI_PBKDF2@
      Connection\PortRangeMin=${toString peerPort}
    '';
  in {
    imports = [
      inputs.vpn-confinement.nixosModules.default
    ];

    # Diagnostic tools
    environment.systemPackages = with pkgs; [
      wireguard-tools
      iproute2
      tcpdump
    ];

    vpnNamespaces."wg" = {
      enable = true;
      wireguardConfigFile = "${cfg.paths.secrets}/mullvad_wireguard_linux_us_slc/us-slc-wg-301.conf";
      accessibleFrom = [ lanCidr ];
      portMappings = [
        { from = webuiPort; to = webuiPort; protocol = "tcp"; }
        { from = peerPort; to = peerPort; protocol = "both"; }
      ];
    };

    systemd.services.qbittorrent.vpnConfinement = {
      enable = true;
      vpnNamespace = "wg";
    };

    services.qbittorrent = {
      enable = true;
      webuiPort = webuiPort;
      serverConfig = lib.mkForce {}; # I override the config
    };

    systemd.services.qbittorrent.preStart = lib.mkAfter ''
      install -d -m 0750 -o ${qbUser} -g ${qbGroup} ${qbConfDir}

      cp ${qbConfTemplate} ${qbConfPath}
      chown ${qbUser}:${qbGroup} ${qbConfPath}
      chmod 0640 ${qbConfPath}

      secret="$(cat ${config.age.secrets.qbittorrent-pass.path})"
      esc="$(printf '%s' "$secret" | ${pkgs.gnused}/bin/sed -e 's/[\/&]/\\&/g')"
      ${pkgs.gnused}/bin/sed -i "s/@QB_WEBUI_PBKDF2@/$esc/g" ${qbConfPath}
    '';

    # Ensure access to download directory
    systemd.tmpfiles.rules = [
      "d ${defaultDir} 0755 ${qbUser} ${qbGroup} - -"
    ];

    networking.firewall.extraInputRules = ''
      ip saddr ${lanCidr} tcp dport ${toString webuiPort} accept
    '';
  };
}

