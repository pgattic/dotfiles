{ lib, ... }: {
  options = {
    my.desktop.corner_radius = lib.mkOption {
      type = lib.types.float;
      description = "Corner radius of Desktop elements";
    };
  };

  config = {

    my.desktop.corner_radius = 8.0;

    flake = {
      nixosModules.desktop-base = { pkgs, ... }: {
        boot.plymouth.enable = true;
        services.xserver.xkb = {
          layout = "us";
          variant = "";
        };

        environment.sessionVariables = {
          NIXOS_OZONE_WL = "1";
        };

        services = {
          greetd = {
            enable = true;
            settings.default_session = {
              command = ''
                ${pkgs.tuigreet}/bin/tuigreet --remember --asterisks --time \
                --time-format "%a %b %d %I:%M %p" \
                --window-padding 2 \
                --theme "border=cyan;action=cyan;time=cyan;button=gray"
              '';
              user = "greeter";
            };
          };
          gvfs.enable = true; # Automatic drive mounting, network shares, recycle bin
        };
      };
      homeModules.desktop-base = { pkgs, ... }: {
        home.packages = with pkgs; [
          wl-clipboard-rs
          wf-recorder
          wl-mirror
          pavucontrol
          brightnessctl
          imv
          mpv-unwrapped
          libnotify
          zathura
          xarchiver
          papirus-icon-theme
          kdePackages.dolphin
        ];

        xdg = {
          # De-clutter desktop entries
          # /etc/profiles/per-user/pgattic/share/applications/
          desktopEntries = {
            "foot-server" = {
              name = "Foot Server";
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
        programs.foot = {
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
          };
        };
      };
    };
  };
}

