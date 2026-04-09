{ inputs, lib, ... }: {
  perSystem = { pkgs, self', ... }: let
    wlib = inputs.nix-wrapper-modules.lib;
    corner_radius = 10.0;
    opacity = 0.85;
    assets = ../../../assets;
    foot = lib.getExe self'.packages.foot;
    btop = lib.getExe self'.packages.btop;

    simpleWidget = { tooltip, icon, cmd }: {
      id = "CustomButton";
      generalTooltipText = tooltip;
      icon = icon;
      leftClickExec = cmd;
      showExecTooltip = false;
      showTextTooltip = false;
    };

    noctalia-base = wlib.evalModule ({
      inherit pkgs;
      imports = [ wlib.wrapperModules.noctalia-shell ];

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
        version = 2;
      };
      pluginSettings.clipper.fullscreenMode = true; # Puts the panel on the bottom of the screen

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
          radiusRatio = corner_radius / 20.0;
          avatarImage = "${assets}/profile.jpg";
        };
        ui = {
          panelBackgroundOpacity = opacity;
          settingsPanelMode = "window";
        };
        notifications.backgroundOpacity = opacity;
        dock.enabled = false;
        bar = {
          # density = if config.my.desktop.touch_options then "default" else "compact";
          showCapsule = false;
          outerCorners = false;
          widgets = {
            left = [
              { id = "Workspace"; }
              { id = "SystemMonitor"; }
              { id = "MediaMini"; maxWidth = 200; showVisualizer = true; showArtistFirst = false; useFixedWidth = true; }
            ];
            center = [
              { id = "ActiveWindow"; maxWidth = 800; }
            ];
            right = [
              { id = "Tray"; drawerEnabled = false; }
              { id = "plugin:clipper"; }
              { id = "Brightness"; }
              { id = "Volume"; }
              { id = "Bluetooth"; }
              { id = "Network"; }
              { id = "Battery"; }
              { id = "NotificationHistory"; }
              { id = "Clock"; formatHorizontal = "ddd MMM dd h:mm AP"; tooltipFormat = "h:mm:ss AP"; }
              { id = "ControlCenter"; useDistroLogo = true; }
            ];
          };
        };
        sessionMenu.powerOptions = [
          { keybind = "1"; action = "lock"; enabled = true; countdownEnabled = false; }
          { keybind = "2"; action = "logout"; enabled = true; countdownEnabled = false; }
          { keybind = "3"; action = "reboot"; enabled = true; }
          { keybind = "4"; action = "shutdown"; enabled = true; }
          { action = "suspend"; enabled = false; }
          { action = "hibernate"; enabled = false; }
          { action = "rebootToUefi"; enabled = false; }
          { action = "userspaceReboot"; enabled = false; }
        ];
        systemMonitor.externalMonitor = "${foot} ${btop}";
        audio.volumeOverdrive = true;
        osd = { # Popup for volume/brightness changes
          location = "bottom";
          backgroundOpacity = opacity;
        };
        nightLight.enabled = true;
        appLauncher = {
          enableClipboardHistory = true; # Required for clipboard manager plugin to work
          terminalCommand = "foot";
          enableSettingsSearch = false;
          # overviewLayer = !config.my.desktop.touch_options; # Gets in the way of OSK
        };
        location = {
          name = "Provo, United States";
          use12hourFormat = true;
          useFahrenheit = true;
        };
        wallpaper = {
          directory = "${assets}/wallpapers";
          transitionType = "stripes";
        };
      };
    });

    noctalia-activate-linux = noctalia-base.config.apply ({ lib, ... }: {
      extraPackages = [ pkgs.cliphist ];
      settings = {
        plugins.states.activate-linux = {
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          enabled = true;
        };
        pluginSettings.activate-linux = {
          customizeText = true;
          firstLine = "Activate Linux";
          secondLine = "Go to Settings to activate Linux.";
        };
      };
    });

    noctalia-touch = noctalia-base.config.apply ({ lib, ... }: {
      extraPackages = [ pkgs.cliphist ];
      settings = {
        appLauncher.viewMode = "grid";
        bar.widgets.left = lib.mkForce [
          { id = "Workspace"; }
          { id = "SystemMonitor"; }
          (simpleWidget { tooltip = "Open Launcher"; icon = "grid-dots"; cmd = "noctalia-shell ipc call launcher toggle"; })
          (simpleWidget { tooltip = "Toggle Overview"; icon = "layout-distribute-horizontal"; cmd = "niri msg action toggle-overview"; })
          (simpleWidget {
            tooltip = "Open/Close On-Screen Keyboard"; icon = "keyboard";
            cmd = "pgrep wvkbd-deskintl >/dev/null && pkill wvkbd-deskintl || exec ${self'.packages.wvkbd-deskintl}/bin/wvkbd-deskintl -L 412";
          })
          { id = "MediaMini"; maxWidth = 200; showVisualizer = true; showArtistFirst = false; useFixedWidth = true; }
        ];
      };
    });

  in {
    packages = {
      noctalia = noctalia-base.config.wrapper;
      noctalia-activate-linux = noctalia-activate-linux.wrapper;
      noctalia-touch = noctalia-touch.wrapper;
    };
  };
}

