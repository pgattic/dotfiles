{
  flake.nixosModules.luanti-server = { pkgs, ... }: {
    services.minetest-server = {
      enable = true;
      gameId = "mineclonia"; # Minecraft ripoff
      world = "/var/lib/minetest/.minetest/worlds/mcl_world"; # TODO: move to tank
      config = {
        name = "pgattic"; # admin player username
        server_name = "Corless Family Mineclonia Server";
        server_description = "Live, Laugh, Love <3";
        server_announce = false; # Don't report to main server list
        motd = "Live, Laugh, Love <3";
        max_users = 15;
        difficulty = "easy";
        bind_address = "0.0.0.0";
        movement_speed_walk = "5.612"; # Minecraft sprint speed
        enable_damage = true;
        creative_mode = false;
      };
    };
    systemd.services.minetest-server.environment.MINETEST_GAME_PATH = pkgs.mineclonia-game; # Package is from overlays
    networking.firewall = {
      allowedTCPPorts = [ 30000 ];
      allowedUDPPorts = [ 30000 ];
    };
  };
}

