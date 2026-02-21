let
  cfg = {
    sourceDir = "/tank/store/cookbook";
    homeDir = "/var/lib/cookbook-site";
    outputDir = "/var/lib/cookbook-site/public";

    user = "cookbook";
    group = "cookbook";

    extraGroups = [ "copypartyaccess" ];

    domain = "cookbook.corlessfamily.net";

    acme = true;
    extraZolaBuildArgs = [ "--force" ];
  };
in {
  flake.nixosModules.cookbook = { lib, pkgs, ... }: {
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = "/var/lib/cookbook-site";
      createHome = false; # let tmpfiles be in charge of ownership
      extraGroups = cfg.extraGroups;
    };
    users.groups.${cfg.group} = { };

    systemd.tmpfiles.rules = [
      "d ${cfg.homeDir} 0755 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.outputDir} 0755 ${cfg.user} ${cfg.group} - -"
    ];

    # One-shot build (also reused by the watcher)
    systemd.services.cookbook-zola-build = {
      description = "Build Zola cookbook site";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.sourceDir;
        UMask = "0022";
      };
      path = [ pkgs.zola pkgs.coreutils ];
      script = ''
        set -euo pipefail
        mkdir -p ${lib.escapeShellArg cfg.outputDir}
        zola build \
          --output-dir ${lib.escapeShellArg cfg.outputDir} \
          ${lib.escapeShellArgs cfg.extraZolaBuildArgs}
      '';
    };

    # Watch for changes and rebuild
    systemd.services.cookbook-zola-watch = {
      description = "Watch Zola cookbook sources and rebuild on change";
      wantedBy = [ "multi-user.target" ];
      after = [ "cookbook-zola-build.service" ];
      requires = [ "cookbook-zola-build.service" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.sourceDir;
        Restart = "always";
        RestartSec = 1;
        UMask = "0022";
      };

      path = [ pkgs.inotify-tools pkgs.zola pkgs.coreutils pkgs.bash ];

      script = ''
        set -euo pipefail

        # Debounce: if a bunch of writes happen quickly (editor save), rebuild once.
        rebuild() {
          echo "[cookbook] rebuilding..."
          zola build --output-dir ${lib.escapeShellArg cfg.outputDir} ${lib.escapeShellArgs cfg.extraZolaBuildArgs}
          echo "[cookbook] done"
        }

        rebuild

        # Watch typical Zola dirs/files; adjust if your site layout differs
        while true; do
          inotifywait -r -e modify,create,delete,move \
            . 2>/dev/null || true

          # small debounce window
          sleep 0.25
          # drain queued events
          while inotifywait -r -t 0.1 -e modify,create,delete,move \
            . 2>/dev/null; do
            true
          done

          rebuild || true
        done
      '';
    };

    services.nginx = {
      enable = true;

      virtualHosts.${cfg.domain} = {
        forceSSL = cfg.acme;
        enableACME = cfg.acme;

        root = cfg.outputDir;

        # Nice defaults for static sites
        locations."/" = {
          extraConfig = ''
            try_files $uri $uri/ =404;
          '';
        };

        extraConfig = ''
          # Cache static assets aggressively; tune to your needs
          location ~* \.(css|js|png|jpg|jpeg|gif|svg|webp|ico|woff2?)$ {
            expires 30d;
            add_header Cache-Control "public, max-age=2592000, immutable";
            try_files $uri =404;
          }
        '';
      };
    };
  };
}

