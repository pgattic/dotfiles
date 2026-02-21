{ inputs, ... }: let port = 3683; in {
  flake.nixosModules.copyparty = { config, lib, ... }: let cfg = config.my.server; in {

    imports = [ inputs.copyparty.nixosModules.default ];
    nixpkgs.overlays = [ inputs.copyparty.overlays.default ];

    users.groups.copypartyaccess = {};

    users.users.copyparty = {
      extraGroups = [ "copypartyaccess" ];
    };

    services.copyparty = {
      enable = true;
      settings = {
        i = "0.0.0.0";
        p = [ port ];
        md-hist = "/var/lib/copyparty/md-hist"; # Store markdown backups externally
        # I was told to put these three for some reason
        xff-hdr = "x-forwarded-for";
        xff-src = [ "127.0.0.1" "::1" ];
        rproxy = 1;
      };
      accounts = {
        pgattic.passwordFile = config.age.secrets.copyparty-pgattic.path;
        skylar.passwordFile = config.age.secrets.copyparty-skylar.path;
      };
      volumes = {
        "/pgattic" = {
          path = "${cfg.paths.store}/pgattic";
          access = {
            A = [ "pgattic" ];
          };
        };
        "/skylar" = {
          path = "${cfg.paths.store}/skylar";
          access = {
            A = [ "skylar" ];
          };
        };
        "/cookbook" = {
          path = "${cfg.paths.store}/cookbook";
          access = {
            A = [ "pgattic" "skylar" ];
          };
        };
      };
    };

    # Make files group readable/writeable
    systemd.services.copyparty.serviceConfig.UMask = lib.mkForce "0022";

    systemd.tmpfiles.rules = [
      "d ${cfg.paths.store}/pgattic 2775 root copypartyaccess - -"
      "d ${cfg.paths.store}/skylar  2775 root copypartyaccess - -"
      "d ${cfg.paths.store}/cookbook 2775 root copypartyaccess - -"
      "d /var/lib/copyparty/md-hist 0700 copyparty copyparty - -"
    ];

    # If perms keep getting broken, replace the tmpfiles rules with this
    # systemd.services.copypartyaccess-acl = {
    #   description = "Ensure default ACLs for copyparty-accessible dirs";
    #   wantedBy = [ "multi-user.target" ];
    #   after = [ "local-fs.target" ];
    #   serviceConfig = { Type = "oneshot"; };
    #   path = [ pkgs.acl pkgs.coreutils ];
    #   script = ''
    #     set -euo pipefail
    #
    #     for d in \
    #       ${lib.escapeShellArg "${cfg.paths.store}/pgattic"} \
    #       ${lib.escapeShellArg "${cfg.paths.store}/skylar"} \
    #       ${lib.escapeShellArg "${cfg.paths.store}/cookbook"}
    #     do
    #       # ensure group and setgid bit
    #       chgrp -R copypartyaccess "$d" || true
    #       chmod 2775 "$d" || true
    #
    #       # ensure existing files are group-writable
    #       chmod -R g+rwX "$d" || true
    #
    #       # defaults for NEW files/dirs
    #       setfacl -R -m g:copypartyaccess:rwx "$d" || true
    #       setfacl -R -m d:g:copypartyaccess:rwx "$d" || true
    #       setfacl -R -m d:o::0 "$d" || true
    #     done
    #   '';
    # };

    services.nginx.virtualHosts."files.${cfg.domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        extraConfig = ''
          client_max_body_size 50000M;
          proxy_read_timeout   600s;
          proxy_send_timeout   600s;
          send_timeout         600s;
        '';
      };
    };
  };
}

