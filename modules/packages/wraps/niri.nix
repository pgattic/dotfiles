{ inputs, lib, ... }: {
  perSystem = { pkgs, self', ... }: let
    wlib = inputs.nix-wrapper-modules.lib;
    corner_radius = 10.0;

    niri-base = wlib.evalModule ({
      inherit pkgs;
      imports = [ wlib.wrapperModules.niri ];

      env = {
        ELECTRON_OZONE_PLATFORM_HINT = "auto"; # Prefer Wayland for electron apps (doesn't always work)
        NIXOS_OZONE_WL = "1";

        # Temporary fix for home-manager-only Nix installations
        SHELL = pkgs.bash; # If a graphical app is asking, my shell is bash
        # EDITOR = "nvim";
        XDG_CURRENT_DESKTOP = "niri";
        XDG_SESSION_DESKTOP = "niri";
      };

      extraPackages = with pkgs; [
        wl-clipboard
        wf-recorder
        wl-mirror
        pavucontrol
        brightnessctl
        libnotify
      ];

      settings = { # https://birdeehub.github.io/nix-wrapper-modules/wrapperModules/niri.html#settings
        # spawn-at-startup = [
        #   { argv = [ "ghostty" "--gtk-single-instance=true" "--quit-after-last-window-closed=false" "--initial-window=false" ]; }
        # ];
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
        screenshot-path = "~/screenshots/%Y-%m-%d %H-%M-%S.png";
        hotkey-overlay.skip-at-startup = true;
        hotkey-overlay.hide-not-bound = true;
        input = {
          keyboard.xkb = {
            layout = "us";
            options = "caps:escape";
          };
          touchpad = {
            tap = _: {};
            dwt = _: {};
            natural-scroll = _: {};
            drag-lock = _: {};
            click-method = "clickfinger";
            tap-button-map = "left-right-middle";
          };
          mouse = {
            accel-speed = -0.7;
          };
          # warp-mouse-to-focus = _: {};
          focus-follows-mouse = _: {
            props.max-scroll-amount = "34%";
          };
        };
        gestures.hot-corners.off = {};
        # recent-windows.off = {}; # This option doesn't exist in the flake yet for some reason
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
            active-color = "#58a6ff";
            inactive-color = "#505050";
            urgent-color = "#9b0000";
          };
          tab-indicator = {
            hide-when-single-tab = true;
            width = 16;
            gap = 8;
            length = _: { props.total-proportion = 1.0; };
            position = "left";
            place-within-column = true;
            gaps-between-tabs = 8;
            corner-radius = corner_radius;
          };
        };
        cursor = {
          hide-when-typing = true;
          hide-after-inactive-ms = 1000;
        };
        window-rules = [
          { # General rules
            geometry-corner-radius = [ corner_radius corner_radius corner_radius corner_radius ];
            clip-to-geometry = true;
          }
          { # KDE Connect Presentation Pointer fix
            matches = [ { app-id = "org.kde.kdeconnect.daemon"; } ];
            open-floating = true;
            open-fullscreen = false;
            default-floating-position = _: { props = { x = 0; y = 0; }; relative-to = "top-left"; };

            # Adjust to monitor's resolution
            min-width = 1920; min-height = 1080;

            tiled-state = true;
            focus-ring.off = {};
            border.off = {};
            draw-border-with-background = false;
          }
        ];
        overview.zoom = 0.5;
        binds = {
          "Mod+Return" = _: { props.hotkey-overlay-title = "Spawn terminal"; content.spawn = [ "foot" ]; };
          "Mod+N" = _: { props.hotkey-overlay-title = "Quick note"; content.spawn = [ "foot" "nvim" "note.md" ]; };
          "Mod+E" = _: { props.hotkey-overlay-title = "File Manager"; content.spawn = [ "dolphin" ]; };

          "Mod+Shift+Slash".show-hotkey-overlay = {};

          # Open/close the Overview: a zoomed-out view of workspaces and windows.
          # You can also move the mouse into the top-left hot corner,
          # or do a four-finger swipe up on a touchpad.
          "Mod+O" = _: { props.repeat = false; content.toggle-overview = {}; };

          "Mod+Shift+Q".close-window = {};

          # Column/workspace focus – arrows
          "Mod+Left".focus-column-left = {};
          "Mod+Down".focus-workspace-down = {};
          "Mod+Up".focus-workspace-up = {};
          "Mod+Right".focus-column-right = {};

          # Column/workspace focus – HJKL
          "Mod+H".focus-column-left = {};
          "Mod+J".focus-workspace-down = {};
          "Mod+K".focus-workspace-up = {};
          "Mod+L".focus-column-right = {};

          # Column/workspace move – arrows
          "Mod+Shift+Left".move-column-left = {};
          "Mod+Shift+Down".move-column-to-workspace-down = {};
          "Mod+Shift+Up".move-column-to-workspace-up = {};
          "Mod+Shift+Right".move-column-right = {};

          # Column/workspace move – HJKL
          "Mod+Shift+H".move-column-left = {};
          "Mod+Shift+J".move-column-to-workspace-down = {};
          "Mod+Shift+K".move-column-to-workspace-up = {};
          "Mod+Shift+L".move-column-right = {};

          # First/last columns
          "Mod+Home".focus-column-first = {};
          "Mod+End".focus-column-last = {};
          "Mod+Shift+Home".move-column-to-first = {};
          "Mod+Shift+End".move-column-to-last = {};

          # Monitor focus
          "Mod+Ctrl+Left".focus-monitor-left = {};
          "Mod+Ctrl+Down".focus-monitor-down = {};
          "Mod+Ctrl+Up".focus-monitor-up = {};
          "Mod+Ctrl+Right".focus-monitor-right = {};
          "Mod+Ctrl+H".focus-monitor-left = {};
          "Mod+Ctrl+J".focus-monitor-down = {};
          "Mod+Ctrl+K".focus-monitor-up = {};
          "Mod+Ctrl+L".focus-monitor-right = {};

          # Move columns between monitors
          "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = {};
          "Mod+Shift+Ctrl+Down".move-column-to-monitor-down = {};
          "Mod+Shift+Ctrl+Up".move-column-to-monitor-up = {};
          "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = {};
          "Mod+Shift+Ctrl+H".move-column-to-monitor-left = {};
          "Mod+Shift+Ctrl+J".move-column-to-monitor-down = {};
          "Mod+Shift+Ctrl+K".move-column-to-monitor-up = {};
          "Mod+Shift+Ctrl+L".move-column-to-monitor-right = {};

          # Workspace focus/move with PageUp/Down & U/I
          "Mod+Page_Down".focus-workspace-down = {};
          "Mod+Page_Up".focus-workspace-up = {};
          "Mod+U".focus-window-down = {};
          "Mod+I".focus-window-up = {};
          "Mod+Shift+Page_Down".move-column-to-workspace-down = {};
          "Mod+Shift+Page_Up".move-column-to-workspace-up = {};
          "Mod+Shift+U".move-workspace-down = {};
          "Mod+Shift+I".move-workspace-up = {};

          # "Whack with a shovel" workspace moves
          "Mod+Ctrl+Page_Down".move-workspace-down = {};
          "Mod+Ctrl+Page_Up".move-workspace-up = {};
          "Mod+Ctrl+U".move-workspace-down = {};
          "Mod+Ctrl+I".move-workspace-up = {};
          # (You had commented-out versions that also reload ironbar.)

          # Scroll bindings (workspace/column navigation)
          "Mod+WheelScrollDown" = _: { props.cooldown-ms = 150; content.focus-workspace-down = {}; };
          "Mod+WheelScrollUp" = _: { props.cooldown-ms = 150; content.focus-workspace-up = {}; };
          "Mod+WheelScrollRight".focus-column-right = {};
          "Mod+WheelScrollLeft".focus-column-left = {};

          # Shift + wheel.enable = horizontal-ish navigation
          "Mod+Shift+WheelScrollDown".focus-column-right = {};
          "Mod+Shift+WheelScrollUp".focus-column-left = {};

          # Ctrl + wheel.enable = overview
          "Mod+Ctrl+WheelScrollDown" = _: { props.cooldown-ms = 150; content.toggle-overview = {}; };
          "Mod+Ctrl+WheelScrollUp" = _: { props.cooldown-ms = 150; content.toggle-overview = {}; };

          # Workspaces 1–9 (focus / move column)
          "Mod+1".focus-workspace = 1;
          "Mod+2".focus-workspace = 2;
          "Mod+3".focus-workspace = 3;
          "Mod+4".focus-workspace = 4;
          "Mod+5".focus-workspace = 5;
          "Mod+6".focus-workspace = 6;
          "Mod+7".focus-workspace = 7;
          "Mod+8".focus-workspace = 8;
          "Mod+9".focus-workspace = 9;

          "Mod+Shift+1".move-column-to-workspace = 1;
          "Mod+Shift+2".move-column-to-workspace = 2;
          "Mod+Shift+3".move-column-to-workspace = 3;
          "Mod+Shift+4".move-column-to-workspace = 4;
          "Mod+Shift+5".move-column-to-workspace = 5;
          "Mod+Shift+6".move-column-to-workspace = 6;
          "Mod+Shift+7".move-column-to-workspace = 7;
          "Mod+Shift+8".move-column-to-workspace = 8;
          "Mod+Shift+9".move-column-to-workspace = 9;

          # Column sizing / fullscreen
          "Mod+R".switch-preset-column-width = {};
          "Mod+Shift+R".switch-preset-window-height = {};
          "Mod+Ctrl+R".reset-window-height = {};
          "Mod+F".maximize-column = {};
          "Mod+Shift+F".fullscreen-window = {};

          "Mod+BracketLeft".consume-or-expel-window-left = {};
          "Mod+BracketRight".consume-or-expel-window-right = {};
          "Mod+Comma".consume-window-into-column = {};
          "Mod+Period".expel-window-from-column = {};

          # Expand column / center column(s)
          "Mod+Ctrl+F".expand-column-to-available-width = {};
          "Mod+C".center-column = {};
          "Mod+Ctrl+C".center-visible-columns = {};

          "Mod+Minus".set-column-width = "-10%";
          "Mod+Equal".set-column-width = "+10%";
          "Mod+Shift+Minus".set-window-height = "-10%";
          "Mod+Shift+Equal".set-window-height = "+10%";

          "Mod+Shift+Space".toggle-window-floating = {};
          # "Mod+Space".switch-focus-between-floating-and-tiling = {};

          "Mod+W".toggle-column-tabbed-display = {};

          # Screenshots
          "Print".screenshot = {};
          "Ctrl+Print".screenshot-screen = {};
          "Mod+Print".screenshot-window = {};

          # Keyboard shortcuts inhibit
          # allow-inhibiting=false on Mod+Escape in your KDL
          # "Mod+Escape".toggle-keyboard-shortcuts-inhibit.enable = true;

          "Mod+Ctrl+Alt+E".quit = {}; # Emergency keybind for when shell is broken
          "Mod+Shift+P".power-off-monitors = {};

          # Disable the keys I only ever hit on accident
          "Home".spawn = [];
          "End".spawn = [];
          "Page_Up".spawn = [];
          "Page_Down".spawn = [];
        };
      };
    });

    mkNiri = noctalia-pkg: niri-base.config.apply ({ lib, ... }: let
      noctalia-cmd = lib.getExe noctalia-pkg;
    in {
      settings = {
        spawn-at-startup = [ [ noctalia-cmd ] ];
        binds = {
          "Mod+Space" = _: { props.hotkey-overlay-title = "Open Lanucher"; content.spawn = [ noctalia-cmd "ipc" "call" "launcher" "toggle" ]; };
          "Mod+Shift+E" = _: { props.hotkey-overlay-title = "Quit niri"; content.spawn = [ noctalia-cmd "ipc" "call" "sessionMenu" "toggle" ]; };

          # The allow-when-locked=true property makes them work even when the session is locked.
          "XF86AudioRaiseVolume"  = _: { props.allow-when-locked = true; content.spawn = [ noctalia-cmd "ipc" "call" "volume" "increase" ]; };
          "XF86AudioLowerVolume"  = _: { props.allow-when-locked = true; content.spawn = [ noctalia-cmd "ipc" "call" "volume" "decrease" ]; };
          "XF86AudioMute"         = _: { props.allow-when-locked = true; content.spawn = [ noctalia-cmd "ipc" "call" "volume" "muteOutput" ]; };
          "XF86AudioMicMute"      = _: { props.allow-when-locked = true; content.spawn = [ noctalia-cmd "ipc" "call" "volume" "muteInput" ]; };
          "XF86MonBrightnessUp"   = _: { props.allow-when-locked = true; content.spawn = [ noctalia-cmd "ipc" "call" "brightness" "increase" ]; };
          "XF86MonBrightnessDown" = _: { props.allow-when-locked = true; content.spawn = [ noctalia-cmd "ipc" "call" "brightness" "decrease" ]; };
        };
      };
    });

    niri = (mkNiri self'.packages.noctalia).apply {
      settings.prefer-no-csd = {};
    };

    niri-activate-linux = (mkNiri self'.packages.noctalia-activate-linux).apply {
      settings.prefer-no-csd = {};
    };

    niri-touch = mkNiri self'.packages.noctalia-touch;

    niri-mobile = (mkNiri self'.packages.noctalia-mobile).apply ({ lib, ... }: {
      settings = {
        window-rules = lib.mkForce [{
          geometry-corner-radius = [ corner_radius corner_radius corner_radius corner_radius ];
          clip-to-geometry = true;
          open-maximized-to-edges = true; # Just wanted to override this
        }];
      };
    });

  in {
    packages = {
      niri = niri.wrapper;
      niri-touch = niri-touch.wrapper;
      niri-mobile = niri-mobile.wrapper;
      niri-activate-linux = niri-activate-linux.wrapper;
    };
  };
}

