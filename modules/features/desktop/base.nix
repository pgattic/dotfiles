let
  hmModule = { pkgs, ... }: {
    # Disable baloo indexer (install ripgrep-all to get search functionality)
    home.file.".config/baloofilerc".text = ''
      [Basic Settings]
      Indexing-Enabled=false
    '';

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "image/png" = "imv-dir.desktop";
        "image/jpeg" = "imv-dir.desktop";
        "video/x-matroska" = "mpv.desktop";
        "video/vnd.avi" = "mpv.desktop";
        "video/mp4" = "mpv.desktop";
      };
    };
  };
in {
  flake = {
    nixosModules.desktop-base = { config, lib, pkgs, ... }: {
      home-manager.users.${config.my.user.name} = hmModule;
      boot.plymouth.enable = true;
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };

      services = {
        upower.enable = lib.mkDefault true;
        greetd = {
          enable = lib.mkDefault true;
          settings.default_session = {
            command = ''
              ${pkgs.tuigreet}/bin/tuigreet --remember --asterisks --time \
              --time-format "%a %b %d %I:%M %p" \
              --window-padding 2 \
              --theme "border=blue;action=blue;time=blue;button=gray"
            '';
            user = "greeter";
          };
        };
      };
    };
    homeModules.desktop-base = hmModule;
  };
}

