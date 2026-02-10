{ inputs, ... }: {
  flake = {
    nixosModules.noctalia = { ... }: {};
    homeModules.noctalia = { lib, pkgs, osConfig, ... }: {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      home.packages = with pkgs; [
        cliphist # For the "clipper" plugin
      ] ++ lib.optionals osConfig.my.desktop.touch_options [
        wvkbd-deskintl
      ];

      programs.niri.settings.spawn-at-startup = [
        { argv = [ "noctalia-shell" ]; }
      ];
      programs.niri.settings.binds = {
        "Mod+Space" = { hotkey-overlay.title = "Open Lanucher"; action.spawn = [ "noctalia-shell" "ipc" "call" "launcher" "toggle" ]; };
        "Mod+Shift+E" = { hotkey-overlay.title = "Quit niri"; action.spawn = [ "noctalia-shell" "ipc" "call" "sessionMenu" "toggle" ]; };
      };

      home.file.".cache/noctalia/wallpapers.json".text = builtins.toJSON {
        defaultWallpaper = "${osConfig.my.user.home_dir}/dotfiles/assets/wallpapers/wedding_temple.jpg";
      };
      stylix.targets.noctalia-shell.enable = false; # I do more precise coloring

      programs.noctalia-shell = {
        enable = true;
        plugins = {
          sources = [
            {
              name = "Official Noctalia Plugins";
              url = "https://github.com/noctalia-dev/noctalia-plugins";
              enabled = true;
            }
          ];
          states = {
            clipper = {
              sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
              enabled = true;
            };
          };
          version = 1;
        };
        colors = { # Copied from the GitHub Dark theme
          mError = "#f85149";
          mHover = "#21262d";
          mOnError = "#010409";
          mOnHover = "#c9d1d9";
          mOnPrimary = "#010409";
          mOnSecondary = "#010409";
          mOnSurface = "#c9d1d9";
          mOnSurfaceVariant = "#8b949e";
          mOnTertiary = "#010409";
          mOutline = "#30363d";
          mPrimary = "#58a6ff";
          mSecondary = "#add3ff"; # was "#bc8cff"
          mShadow = "#010409";
          mSurface = "#010409";
          mSurfaceVariant = "#161b22";
          mTertiary = "#add3ff"; # was "#bc8cff"
        };
        settings = {
          general = {
            enableShadows = false;
            radiusRatio = osConfig.my.desktop.corner_radius / 20.0;
            avatarImage = "${osConfig.my.user.home_dir}/dotfiles/assets/profile.jpg";
          };
          ui = {
            panelBackgroundOpacity = osConfig.my.desktop.opacity;
            settingsPanelMode = "window";
          };
          notifications.backgroundOpacity = osConfig.my.desktop.opacity;
          dock.enabled = false;
          bar = {
            density = if osConfig.my.desktop.touch_options then "default" else "compact";
            showCapsule = false;
            outerCorners = false;
            widgets = {
              left = [
                {
                  id = "Workspace";
                  labelMode = "none";
                  focusedColor = "primary";
                  occupiedColor = "onSurface";
                  emptyColor = "onSurface";
                }
                { id = "SystemMonitor"; }
              ]
              ++ lib.optionals osConfig.my.desktop.touch_options [
                { id = "Launcher"; }
                { id = "CustomButton"; icon = "layout-grid-filled"; leftClickExec = "niri msg action toggle-overview"; }
                { id = "CustomButton"; icon = "keyboard"; leftClickExec = "pgrep wvkbd-deskintl >/dev/null && pkill wvkbd-deskintl || exec ${pkgs.wvkbd-deskintl}/bin/wvkbd-deskintl -L 412"; }
              ]
              ++ [
                { id = "MediaMini"; maxWidth = 200; showVisualizer = true; showArtistFirst = false; useFixedWidth = true; }
              ];
              center = [
                { id = "ActiveWindow"; maxWidth = 800; }
              ];
              right = [
                { id = "Tray"; drawerEnabled = false; }
                { id = "plugin:clipper"; }
                { id = "NotificationHistory"; }
                { id = "Brightness"; }
                { id = "Volume"; }
                { id = "Bluetooth"; }
                { id = "Network"; }
                { id = "Battery"; }
                { id = "Clock"; formatHorizontal = "ddd MMM dd h:mm AP"; tooltipFormat = "h:mm:ss AP"; }
                { id = "ControlCenter"; useDistroLogo = true; enableColorization = true; colorizeSystemIcon = "primary"; }
              ];
            };
          };
          sessionMenu = {
            showHeader = false;
            powerOptions = [
              { action = "lock"; enabled = true; countdownEnabled = false; }
              { action = "logout"; enabled = true; countdownEnabled = false; }
              { action = "reboot"; enabled = true; }
              { action = "shutdown"; enabled = true; }
              { action = "suspend"; enabled = false; }
              { action = "hibernate"; enabled = false; }
            ];
          };
          systemMonitor.externalMonitor = "foot btop";
          audio.volumeOverdrive = true;
          osd.location = "bottom";
          nightLight.enabled = true;
          appLauncher = {
            enableClipboardHistory = true; # Required for clipboard manager plugin to work
            terminalCommand = "foot";
            enableSettingsSearch = false;
            viewMode = if osConfig.my.desktop.touch_options then "grid" else "list";
            overviewLayer = true;
          };
          location = {
            name = "Provo, United States";
            use12hourFormat = true;
            useFahrenheit = true;
          };
          wallpaper = {
            directory = "${osConfig.my.user.home_dir}/dotfiles/assets/wallpapers";
            transitionType = "stripes";
          };
        };
      };
    };
  };
}

