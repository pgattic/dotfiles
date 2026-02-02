{
  flake.nixosModules.minecraft-bedrock-server = { pkgs, ... }: {
    virtualisation.podman.enable = true;

    # The oci-containers module manages the container as a systemd service
    virtualisation.oci-containers = {
      backend = "podman";

      containers.bedrock = { # Minecraft Bedrock Server
        # podman logs -f bedrock
        # podman exec -it bedrock /bin/bash
        # # The image includes a helper to send server commands:
        # podman exec bedrock send-command "op \"YourGamertag\""
        image = "docker.io/itzg/minecraft-bedrock-server:latest";
        autoStart = true;
        volumes = [ "/var/lib/bedrock:/data" ]; # Location where world is stored
        ports = [ "19132:19132/udp" ];

        environment = {
          VERSION = "1.21.60.10";
          EULA = "TRUE";
          TZ = "America/Boise";

          SERVER_NAME = "Corless Family Server";
          GAMEMODE = "survival";
          DIFFICULTY = "easy";
          ONLINE_MODE = "true"; # Xbox Account requirement
          LEVEL_NAME = "world";
          ALLOW_LIST = "false"; # Whitelist
          # ALLOW_LIST_USERS = "Player1:1234567890,Player2:0987654321";
          # LEVEL_SEED = "12345";
        };

        extraOptions = [
          "--dns=1.1.1.1"
          # OPTIONAL: if you have a local search domain
          # "--dns-search=lan"
        ];
      };
    };

    # Create/persist the data dir with sane perms
    users.groups.bedrock = { };
    users.users.bedrock = { isSystemUser = true; group = "bedrock"; home = "/var/lib/bedrock"; };
    systemd.tmpfiles.rules = [ "d /var/lib/bedrock 0750 bedrock bedrock -" ];

    networking.firewall.allowedUDPPorts = [ 19132 ];
  };
}

