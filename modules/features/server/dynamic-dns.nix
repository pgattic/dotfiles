{
  flake.nixosModules.dynamic-dns = { config, pkgs, ... }:
  let
    cfg = config.my.server;
    ddnsScript = pkgs.writeShellScript "namecheap-ddns" ''
      set -euo pipefail

      HOSTS=("@" "www" "cinema" "cookbook" "files" "finances" "keep" "library" "photos" "roms")
      DOMAIN="${cfg.domain}"

      : "''${NAMECHEAP_DDNS_PASSWORD:?missing NAMECHEAP_DDNS_PASSWORD}"

      for HOST in "''${HOSTS[@]}"; do
        ${pkgs.curl}/bin/curl -fsS \
          "https://dynamicdns.park-your-domain.com/update?host=$HOST&domain=$DOMAIN&password=$NAMECHEAP_DDNS_PASSWORD" \
          >/dev/null
      done
    '';
  in {
    # sudo journalctl -u acme-corlessfamily.net.service
    security.acme = {
      acceptTerms = true;
      defaults.email = config.my.user.email;
      # validMinDays = 999; # Uncomment for one rebuild to force immediate renewal
    };

    systemd.services.namecheap-ddns = {
      description = "Update Namecheap Dynamic DNS";
      serviceConfig = {
        Type = "oneshot";
        EnvironmentFile = config.age.secrets.namecheap-dns-env.path;
        ExecStart = ddnsScript;
        User = "root";
        # basic hardening for a network-only oneshot
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
      };
    };

    systemd.timers.namecheap-ddns = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "5min";
        OnUnitActiveSec = "5min";
        Persistent = true;
        RandomizedDelaySec = "60s";
      };
    };
  };
}

