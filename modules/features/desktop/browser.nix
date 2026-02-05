{ config, ... }: {
  flake = {
    nixosModules.browser = { ... }: {};
    homeModules.browser = { ... }: {
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
          search.force = true;
          search.default = "google";
          search.engines = {
            google = {
              name = "Google";
              urls = [{
                template = "https://www.google.com/search";
                params = [{ name = "q"; value = "{searchTerms}"; }];
              }];

              icon = "https://www.google.com/favicon.ico";
              definedAliases = [ "@g" ];
            };
            nix-packages = {
              name = "NixOS Packages";
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "channel"; value = "unstable"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              icon = "https://search.nixos.org/favicon-96x96.png";
              definedAliases = [ "@nix" ];
            };
            home-manager = {
              name = "Home Manager Options";
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "query"; value = "{searchTerms}"; }
                  { name = "release"; value = "master"; }
                ];
              }];
              icon = "https://home-manager-options.extranix.com/images/favicon.png";
              definedAliases = [ "@hm" ];
            };
          };
          settings = {
            # Librewolf-specific stuff
            "privacy.resistFingerprinting" = false; # Unfortunately required for muh dark mode to work
            "privacy.clearOnShutdown.history" = false;
            "privacy.clearOnShutdown.cookies" = false;
            "network.cookie.lifetimePolicy" = 0;
            "webgl.disabled" = false;

            # Firefox stuff
            "browser.gesture.swipe.left" = "cmd_scrollLeft";
            "browser.gesture.swipe.right" = "cmd_scrollRight";
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable UserChrome.css
            "sidebar.verticalTabs" = true;
            "browser.toolbars.bookmarks.visibility" = "never"; # "always", "never", "newtab"
            "browser.tabs.inTitleBar" = 0; # Hide client-side decorations
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
                TabsToolbar = [];
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

