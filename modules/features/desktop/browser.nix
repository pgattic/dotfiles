let
  hmModule = { config, pkgs, ... }: {
    programs.librewolf = {
      enable = true;

      profiles."${config.my.user.name}" = {
        extensions = {
          force = true;
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            bitwarden
            qr-code-address-bar
            simple-tab-groups
            vimium
            wappalyzer
          ];
        };
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
          wikipedia = {
            name = "Wikipedia";
            urls = [{
              template = "https://en.wikipedia.org/w/index.php";
              params = [
                { name = "search"; value = "{searchTerms}"; }
              ];
            }];
            icon = "https://en.wikipedia.org/static/favicon/wikipedia.ico";
            definedAliases = [ "@w" ];
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
              template = "https://home-manager-options.extranix.com";
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
          "privacy.clearOnShutdown.cache" = false;
          "privacy.clearOnShutdown.sessions" = false;
          "network.cookie.lifetimePolicy" = 0;
          "webgl.disabled" = false;

          # Firefox stuff
          "findbar.highlightAll" = true;
          "browser.gesture.swipe.left" = "cmd_scrollLeft";
          "browser.gesture.swipe.right" = "cmd_scrollRight";
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable UserChrome.css
          "sidebar.verticalTabs" = true;
          "sidebar.main.tools" = "simple-tab-groups@drive4ik";
          "browser.toolbars.bookmarks.visibility" = "never"; # "always", "never", "newtab"
          "browser.tabs.inTitleBar" = 0; # Hide client-side decorations
          "browser.startup.page" = 3; # Reopen last session on start
          "browser.uiCustomization.state" = builtins.toJSON {
            placements = {
              widget-overflow-fixed-list = [ ];
              unified-extensions-area = [ # If I don't put extensions here, they'll get put in the navbar
                "simple-tab-groups_drive4ik-browser-action"
                "_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action" # Vimium
                "firefoxcolor_mozilla_com-browser-action"
              ];
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
                "wappalyzer_crunchlabz_com-browser-action"
                "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action" # BitWarden
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

    xdg.mimeApps = {
      defaultApplications = {
        "text/html" = "librewolf.desktop";
        "x-scheme-handler/http" = "librewolf.desktop";
        "x-scheme-handler/https" = "librewolf.desktop";
      };
    };
  };
in {
  flake = {
    nixosModules.browser = { config, ... }: {
      home-manager.users.${config.my.user.name}.imports = [ hmModule ];
    };

    homeModules.browser = hmModule;
  };
}

