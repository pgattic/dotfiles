{ config, ... }: {
  flake = {
    nixosModules.browser = { ... }: {};
    homeModules.browser = { pkgs, ... }: {
      home.packages = with pkgs; [
        bitwarden-desktop
      ];
      programs.librewolf = {
        enable = true;

        profiles."${config.my.user.name}" = {
          extensions.force = true;
          bookmarks.force = true;
          bookmarks.settings = [
            { "name" = "NixOS Search"; url = "https://search.nixos.org"; tags = ["nixos" "search"]; }
            { "name" = "Home Manager Options"; url = "https://home-manager-options.extranix.com"; tags = ["home" "nixos" "search"]; }
            { "name" = "pgattic.dev"; url = "https://pgattic.dev"; }
          ];
          settings = {
            "browser.gesture.swipe.left" = "cmd_scrollLeft";
            "browser.gesture.swipe.right" = "cmd_scrollRight";
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable UserChrome.css
            "privacy.resistFingerprinting" = false; # (Librewolf-exclusive) unfortunately required for muh dark mode to work
            "sidebar.verticalTabs" = true;
            "browser.toolbars.bookmarks.visibility" = "newtab";
            "browser.tabs.inTitleBar" = 0; # How to hide client-side decorations
            "browser.startup.page" = 3; # Reopen last session on start
            "browser.uiCustomization.state" = builtins.toJSON {
              placements = {
                widget-overflow-fixed-list = [ ];
                # unified-extensions-area = [
                #   "firefoxcolor_mozilla_com-browser-action"
                # ];
                nav-bar = [
                  # "sidebar-button"
                  "back-button"
                  "forward-button"
                  "stop-reload-button"
                  "customizableui-special-spring1"
                  "vertical-spacer"
                  "urlbar-container"
                  "customizableui-special-spring2"
                  "downloads-button"
                  "fxa-toolbar-menu-button"
                  # "unified-extensions-button"
                  "ublock0_raymondhill_net-browser-action"
                  # "alltabs-button"
                ];
                toolbar-menubar = [
                  "menubar-items"
                ];
                TabsToolbar = [

                ];
                vertical-tabs = [
                  "tabbrowser-tabs"
                ];
                PersonalToolbar = [
                  "personal-bookmarks"
                ];
              };
              seen = [
                "developer-button"
                "screenshot-button"
                "ublock0_raymondhill_net-browser-action"
                "firefoxcolor_mozilla_com-browser-action"
              ];
              dirtyAreaCache = [
                "nav-bar"
                "vertical-tabs"
                "unified-extensions-area"
                "TabsToolbar"
                "toolbar-menubar"
                "PersonalToolbar"
              ];
              currentVersion = 23;
              newElementCount = 2;
            };
          };
          # Fix sidebar showing in fullscreen
          userChrome = ''
            :root[sizemode="fullscreen"] #sidebar-main { visibility: collapse }
          '';
        };
      };

      stylix.targets.librewolf = {
        profileNames = [ config.my.user.name ];
        colorTheme.enable = true;
      };
    };
  };
}

