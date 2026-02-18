{ inputs, ... }: let
  hmModule = { config, pkgs, ... }: {
    imports = [
      inputs.niri.homeModules.config # https://github.com/sodiboo/niri-flake
    ];

    home.packages = with pkgs; [
      xwayland-satellite
    ];

    programs.niri = {
      package = pkgs.niri;
      settings = { # https://github.com/sodiboo/niri-flake/blob/main/docs.md
        # spawn-at-startup = [
        #   { argv = [ "ghostty" "--gtk-single-instance=true" "--quit-after-last-window-closed=false" "--initial-window=false" ]; }
        # ];
        screenshot-path = "~/screenshots/%Y-%m-%d %H-%M-%S.png";
        environment = {
          ELECTRON_OZONE_PLATFORM_HINT = "auto"; # Prefer Wayland for electron apps (doesn't always work)
          DISPLAY = ":0"; # required for X11 apps to connect to xwayland-satellite properly

          # Temporary fix for home-manager-only Nix installations
          SHELL = "nu";
          EDITOR = "nvim";
          XDG_CURRENT_DESKTOP = "niri";
          XDG_SESSION_DESKTOP = "niri";
          NH_HOME_FLAKE = "${config.my.user.home_dir}/dotfiles";
          NIXOS_OZONE_WL = "1";
        };
        hotkey-overlay.skip-at-startup = true;
        hotkey-overlay.hide-not-bound = true;
        input = {
          keyboard.xkb.options = "caps:escape";
          touchpad = {
            tap = true;
            # dwt = true; # Disable when typing
            natural-scroll = true;
            drag-lock = true;
            click-method = "clickfinger";
            tap-button-map = "left-right-middle";
          };
          mouse = {
            accel-speed = -0.7;
          };
          # warp-mouse-to-focus.enable = true;
          focus-follows-mouse = {
            enable = true;
            max-scroll-amount = "34%";
          };
        };
        gestures.hot-corners.enable = false;
        # recent-windows.enable = false; # This option doesn't exist in the flake yet for some reason
        layout = {
          gaps = 8;
          always-center-single-column = true;
          preset-column-widths = [
            { proportion = 1. / 3.; }
            { proportion = 1. / 2.; }
            { proportion = 2. / 3.; }
          ];
          default-column-width.proportion = 1. / 2.;
          focus-ring = {
            width = 2;
            active.color = "#58a6ff";
            inactive.color = "#505050";
            urgent.color = "#9b0000";
          };
          tab-indicator = {
            hide-when-single-tab = true;
            width = 16;
            gap = 8;
            length.total-proportion = 1.0;
            position = "left";
            place-within-column = true;
            gaps-between-tabs = 8;
            corner-radius = config.my.desktop.corner_radius;
          };
        };
        cursor = {
          hide-when-typing = true;
          hide-after-inactive-ms = 1000;
        };
        prefer-no-csd = !config.my.desktop.touch_options;
        window-rules = [
          { # General rules
            geometry-corner-radius = {
              bottom-left = config.my.desktop.corner_radius;
              bottom-right = config.my.desktop.corner_radius;
              top-left = config.my.desktop.corner_radius;
              top-right = config.my.desktop.corner_radius;
            };
            clip-to-geometry = true;
          }
          { # KDE Connect Presentation Pointer fix
            matches = [ { app-id = "org.kde.kdeconnect.daemon"; } ];
            open-floating = true;
            open-fullscreen = false;
            default-floating-position = { x = 0; y = 0; relative-to = "top-left"; };

            # Adjust to monitor's resolution
            min-width = 1920; min-height = 1080;

            tiled-state = true;
            focus-ring.enable = false;
            border.enable = false;
            shadow.enable = false;
            draw-border-with-background = false;
          }
        ];
        overview.zoom = 0.25;
        binds = {
          "Mod+Shift+Slash".action.show-hotkey-overlay = {};

          "Mod+Return" = { hotkey-overlay.title = "Spawn terminal"; action.spawn = [ "foot" ]; };
          # "Mod+Return".action.spawn = [ "ghostty" "--gtk-single-instance=true" ];
          "Mod+N" = { hotkey-overlay.title = "Quick note"; action.spawn = [ "foot" "nvim" "note.md" ]; };
          # "Mod+N".action.spawn = [ "ghostty" "--gtk-single-instance=true" "-e" "nvim" "note.md" ];
          # "Mod+T".action.spawn = [ "kitten" "quick-access-terminal" ];
          "Mod+E" = { hotkey-overlay.title = "File Manager"; action.spawn = [ "dolphin" ]; };
          # "Super+Alt+L".action.spawn = [ "swaylock" ];

          # The allow-when-locked=true property makes them work even when the session is locked.
          "XF86AudioRaiseVolume" = { allow-when-locked = true; action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+" ]; };
          "XF86AudioLowerVolume" = { allow-when-locked = true; action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-" ]; };
          "XF86AudioMute" = { allow-when-locked = true; action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ]; };
          "XF86AudioMicMute" = { allow-when-locked = true; action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ]; };

          "XF86MonBrightnessUp".action.spawn = [ "brightnessctl" "set" "10%+" ];
          "XF86MonBrightnessDown".action.spawn = [ "brightnessctl" "set" "10%-" ];

          # Open/close the Overview: a zoomed-out view of workspaces and windows.
          # You can also move the mouse into the top-left hot corner,
          # or do a four-finger swipe up on a touchpad.
          "Mod+O" = { repeat = false; action.toggle-overview = {}; };

          "Mod+Shift+Q".action.close-window = {};

          # Column/workspace focus – arrows
          "Mod+Left".action.focus-column-left = {};
          "Mod+Down".action.focus-workspace-down = {};
          "Mod+Up".action.focus-workspace-up = {};
          "Mod+Right".action.focus-column-right = {};

          # Column/workspace focus – HJKL
          "Mod+H".action.focus-column-left = {};
          "Mod+J".action.focus-workspace-down = {};
          "Mod+K".action.focus-workspace-up = {};
          "Mod+L".action.focus-column-right = {};

          # Column/workspace move – arrows
          "Mod+Shift+Left".action.move-column-left = {};
          "Mod+Shift+Down".action.move-column-to-workspace-down = {};
          "Mod+Shift+Up".action.move-column-to-workspace-up = {};
          "Mod+Shift+Right".action.move-column-right = {};

          # Column/workspace move – HJKL
          "Mod+Shift+H".action.move-column-left = {};
          "Mod+Shift+J".action.move-column-to-workspace-down = {};
          "Mod+Shift+K".action.move-column-to-workspace-up = {};
          "Mod+Shift+L".action.move-column-right = {};

          # First/last columns
          "Mod+Home".action.focus-column-first = {};
          "Mod+End".action.focus-column-last = {};
          "Mod+Shift+Home".action.move-column-to-first = {};
          "Mod+Shift+End".action.move-column-to-last = {};

          # Monitor focus
          "Mod+Ctrl+Left".action.focus-monitor-left = {};
          "Mod+Ctrl+Down".action.focus-monitor-down = {};
          "Mod+Ctrl+Up".action.focus-monitor-up = {};
          "Mod+Ctrl+Right".action.focus-monitor-right = {};
          "Mod+Ctrl+H".action.focus-monitor-left = {};
          "Mod+Ctrl+J".action.focus-monitor-down = {};
          "Mod+Ctrl+K".action.focus-monitor-up = {};
          "Mod+Ctrl+L".action.focus-monitor-right = {};

          # Move columns between monitors
          "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = {};
          "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = {};
          "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = {};
          "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = {};
          "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = {};
          "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = {};
          "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = {};
          "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = {};

          # Workspace focus/move with PageUp/Down & U/I
          "Mod+Page_Down".action.focus-workspace-down = {};
          "Mod+Page_Up".action.focus-workspace-up = {};
          "Mod+U".action.focus-window-down = {};
          "Mod+I".action.focus-window-up = {};
          "Mod+Shift+Page_Down".action.move-column-to-workspace-down = {};
          "Mod+Shift+Page_Up".action.move-column-to-workspace-up = {};
          "Mod+Shift+U".action.move-workspace-down = {};
          "Mod+Shift+I".action.move-workspace-up = {};

          # "Whack with a shovel" workspace moves
          "Mod+Ctrl+Page_Down".action.move-workspace-down = {};
          "Mod+Ctrl+Page_Up".action.move-workspace-up = {};
          "Mod+Ctrl+U".action.move-workspace-down = {};
          "Mod+Ctrl+I".action.move-workspace-up = {};
          # (You had commented-out versions that also reload ironbar.)

          # Scroll bindings (workspace/column navigation)
          "Mod+WheelScrollDown" = { action.focus-workspace-down = {}; cooldown-ms = 150; };
          "Mod+WheelScrollUp" = { action.focus-workspace-up = {}; cooldown-ms = 150; };
          "Mod+WheelScrollRight".action.focus-column-right = {};
          "Mod+WheelScrollLeft".action.focus-column-left = {};

          # Shift + wheel.enable = horizontal-ish navigation
          "Mod+Shift+WheelScrollDown".action.focus-column-right = {};
          "Mod+Shift+WheelScrollUp".action.focus-column-left = {};

          # Ctrl + wheel.enable = overview
          "Mod+Ctrl+WheelScrollDown" = { action.toggle-overview = {}; cooldown-ms = 150; };
          "Mod+Ctrl+WheelScrollUp" = { action.toggle-overview = {}; cooldown-ms = 150; };

          # Workspaces 1–9 (focus / move column)
          "Mod+1".action.focus-workspace = 1;
          "Mod+2".action.focus-workspace = 2;
          "Mod+3".action.focus-workspace = 3;
          "Mod+4".action.focus-workspace = 4;
          "Mod+5".action.focus-workspace = 5;
          "Mod+6".action.focus-workspace = 6;
          "Mod+7".action.focus-workspace = 7;
          "Mod+8".action.focus-workspace = 8;
          "Mod+9".action.focus-workspace = 9;

          "Mod+Shift+1".action.move-column-to-workspace = 1;
          "Mod+Shift+2".action.move-column-to-workspace = 2;
          "Mod+Shift+3".action.move-column-to-workspace = 3;
          "Mod+Shift+4".action.move-column-to-workspace = 4;
          "Mod+Shift+5".action.move-column-to-workspace = 5;
          "Mod+Shift+6".action.move-column-to-workspace = 6;
          "Mod+Shift+7".action.move-column-to-workspace = 7;
          "Mod+Shift+8".action.move-column-to-workspace = 8;
          "Mod+Shift+9".action.move-column-to-workspace = 9;

          # Column sizing / fullscreen
          "Mod+R".action.switch-preset-column-width = {};
          "Mod+Shift+R".action.switch-preset-window-height = {};
          "Mod+Ctrl+R".action.reset-window-height = {};
          "Mod+F".action.maximize-column = {};
          "Mod+Shift+F".action.fullscreen-window = {};

          "Mod+BracketLeft".action.consume-or-expel-window-left = {};
          "Mod+BracketRight".action.consume-or-expel-window-right = {};
          "Mod+Comma".action.consume-window-into-column = {};
          "Mod+Period".action.expel-window-from-column = {};

          # Expand column / center column(s)
          "Mod+Ctrl+F".action.expand-column-to-available-width = {};
          "Mod+C".action.center-column = {};
          "Mod+Ctrl+C".action.center-visible-columns = {};

          "Mod+Minus".action.set-column-width = "-10%";
          "Mod+Equal".action.set-column-width = "+10%";
          "Mod+Shift+Minus".action.set-window-height = "-10%";
          "Mod+Shift+Equal".action.set-window-height = "+10%";

          "Mod+Shift+Space".action.toggle-window-floating = {};
          # "Mod+Space".action.switch-focus-between-floating-and-tiling = {};

          "Mod+W".action.toggle-column-tabbed-display = {};

          # Screenshots
          "Print".action.screenshot = {};
          "Ctrl+Print".action.screenshot-screen = {};
          "Mod+Print".action.screenshot-window = {};

          # Keyboard shortcuts inhibit
          # allow-inhibiting=false on Mod+Escape in your KDL
          # "Mod+Escape".action.toggle-keyboard-shortcuts-inhibit.enable = true;

          "Ctrl+Alt+Delete".action.quit = {}; # Emergency keybind for when shell is broken
          "Mod+Shift+P".action.power-off-monitors = {};

          # Disable the keys I only ever hit on accident
          "Home".action.spawn = [];
          "End".action.spawn = [];
          "Page_Up".action.spawn = [];
          "Page_Down".action.spawn = [];
        };
      };
    };
  };
in {
  flake = {
    nixosModules.niri = { config, ... }: {
      home-manager.users.${config.my.user.name}.imports = [ hmModule ];
      programs.niri = {
        enable = true;
        useNautilus = false; # Silly default options
      };
      environment.sessionVariables = {
        XDG_CURRENT_DESKTOP = "niri";
        XDG_SESSION_DESKTOP = "niri";
      };
    };

    homeModules.niri = hmModule;
  };
}

