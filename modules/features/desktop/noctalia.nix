{ config, inputs, ... }: {
  flake = {
    nixosModules.noctalia = { pkgs, ... }: {};
    homeModules.noctalia = { pkgs, ... }: {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      home.packages = with pkgs; [
        cliphist # For the "clipper" plugin
      ];

      programs.niri.settings.spawn-at-startup = [
        { argv = [ "noctalia-shell" ]; }
      ];
      programs.niri.settings.binds = {
        "Mod+Space" = { hotkey-overlay.title = "Open Lanucher"; action.spawn = [ "noctalia-shell" "ipc" "call" "launcher" "toggle" ]; };
        "Mod+Shift+E" = { hotkey-overlay.title = "Quit niri"; action.spawn = [ "noctalia-shell" "ipc" "call" "sessionMenu" "toggle" ]; };
      };

      # home.file.".cache/noctalia/wallpapers.json".text = builtins.toJSON {
      #   defaultWallpaper = "${config.my.user.home_dir}/dotfiles/wallpaper/wedding_temple.jpg";
      # }; # {"defaultWallpaper":"/home/pgattic/dotfiles/wallpaper/wedding_temple.jpg"}

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
        settings = {
          general = {
            enableShadows = false;
            radiusRatio = config.my.desktop.corner_radius / 20.0;
          };
          dock.enabled = false;
          bar = {
            # density = if touch_options then "default" else "compact";
            density = "compact";
            showCapsule = false;
            outerCorners = false;
            widgets = {
              left = [
                { id = "Workspace"; labelMode = "none"; }
                { id = "SystemMonitor"; }
              ]
              # ++ lib.optionals touch_options [
              #   { id = "Launcher"; }
              #   { id = "CustomButton"; icon = "layout-grid-filled"; leftClickExec = "niri msg action toggle-overview"; }
              #   { id = "CustomButton"; icon = "keyboard"; leftClickExec = "pgrep wvkbd-deskintl >/dev/null && pkill wvkbd-deskintl || exec wvkbd-deskintl -L 412"; }
              # ]
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
          appLauncher = {
            terminalCommand = "foot";
            # viewMode = if touch_options then "grid" else "list";
          };
          location = {
            name = "Provo, United States";
            use12hourFormat = true;
            useFahrenheit = true;
          };
          wallpaper = {
            directory = "${config.my.user.home_dir}/dotfiles/config/wallpaper";
            transitionType = "stripes";
          };
        };
      };
    };
  };
}

