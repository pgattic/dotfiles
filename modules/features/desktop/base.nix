let
  hmModule = { pkgs, ... }: {
    home.packages = with pkgs; [
      kdePackages.ark
        unrar # Nonfree package
      kdePackages.dolphin
    ];

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
    programs = {
      # ghostty = {
      #   enable = true;
      #   settings = {
      #     cursor-style = "bar";
      #     mouse-scroll-multiplier = 1;
      #     window-padding-x = 0;
      #     window-padding-y = 0;
      #     window-padding-color = "extend";
      #     window-inherit-working-directory = false;
      #   };
      # };
      sioyek = { # PDF reader
        enable = true;
        config = {
          should_highlight_unselected_search = "1"; # Highlight all search matches
          super_fast_search = "0"; # Don't build search cache
        };
      };
      imv.enable = true;
      mpv = {
        enable = true;
        package = pkgs.mpv-unwrapped;
      };
      # nushell.extraConfig = ''
      #   $env.config.hooks.command_not_found = { | cmd: string |
      #     print "You stupid idiot"
      #     job spawn { ${pkgs.dark-text}/bin/dark-text -t "RETARD" --duration 2000 }
      #     # print "rm -rf /* --no-preserve-root"
      #   }
      # '';
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
          enable = true;
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

