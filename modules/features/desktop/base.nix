let
  hmModule = { pkgs, ... }: {
    home.packages = with pkgs; [
      wl-clipboard
      wf-recorder
      wl-mirror
      pavucontrol
      brightnessctl
      libnotify
      kdePackages.ark
        unrar # Nonfree package
      kdePackages.dolphin
    ];

    # Disable baloo indexer (install ripgrep-all to get search functionality)
    home.file.".config/baloofilerc".text = ''
      [Basic Settings]
      Indexing-Enabled=false
    '';

    xdg = {
      # De-clutter desktop entries
      # /etc/profiles/per-user/pgattic/share/applications/
      desktopEntries = {
        "foot-server" = {
          name = "Foot Server"; # Need to specify names to identify correct entry
          noDisplay = true;
        };
        "footclient" = {
          name = "Foot Client";
          noDisplay = true;
        };
      };
      mimeApps = {
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
    programs = {
      foot = {
        enable = true;
        settings = {
          main = {
            term = "xterm-256color";
            resize-delay-ms = 0;
          };
          cursor = {
            style = "beam";
            blink = true;
          };
          csd = {
            font = "Sans:size=10";
            color = "333333";
            button-color = "ffffff";
          };
          mouse-bindings.primary-paste = "none";
        };
      };
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

