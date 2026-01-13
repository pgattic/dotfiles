{ config, lib, pkgs, inputs, ... }: {
  imports = [
    inputs.niri.homeModules.config # https://github.com/sodiboo/niri-flake
  ];

  options.my.desktop = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable the desktop configurations and packages";
    };

    enable_bluetooth = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable Bluetooth-related applications/configs";
    };

    # cpu_cores = mkOption {
    #   type = types.int;
    #   default = 8;
    #   description = "Number of CPU cores (used by Waybar module)";
    # };

    mod_key = mkOption {
      type = types.enum [ "Super" "Alt" ];
      default = "Super";
      description = "Mod key to use for main desktop navigation (used by Niri module)";
    };

    touch_options = mkOption {
      # type = types.enum [ "off" "full" "supplementary" ];
      type = types.bool;
      default = false;
      description = "Adds client-side decorations and other stuff";
    };
  };

  config = lib.mkIf config.my.desktop.enable {
    home.packages = with pkgs; [
      wl-clipboard-rs

      wf-recorder
      wl-mirror
      swaynotificationcenter
      wbg
      pavucontrol
      brightnessctl
      imv
      mpv-unwrapped
      zathura
      xarchiver
      xwayland-satellite
      bibata-cursors
      papirus-icon-theme
      kdePackages.dolphin
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ]
    ++ lib.optionals config.my.desktop.enable_bluetooth [
      overskride # Bluetooth manager
    ];

    programs = {
      foot = {
        enable = true;
        settings = {
          main = {
            shell = "nu";
            term = "xterm-256color";
            font = "JetBrainsMono Nerd Font:size=10";
            resize-delay-ms = 0;
          };
          cursor = {
            style = "beam";
            blink = true;
          };
          colors = {
            # alpha = 0.8
            foreground = "cccccc";
            background = "1e1e1e";
            regular0 = "000000";
            regular1 = "cd3131";
            regular2 = "0dbc79";
            regular3 = "e5e510";
            regular4 = "2472c8";
            regular5 = "bc3fbc";
            regular6 = "11a8cd";
            regular7 = "e5e5e5";
            bright0 = "666666";
            bright1 = "f14c4c";
            bright2 = "23d18b";
            bright3 = "f5f543";
            bright4 = "3b8eea";
            bright5 = "d670d6";
            bright6 = "29b8db";
            bright7 = "e5e5e5";
          };
          csd = {
            font = "Sans:size=10";
            color = "333333";
            button-color = "ffffff";
          };
        };
      };
      niri = {
        # enable = true;
        package = pkgs.niri;
        settings = { # https://github.com/sodiboo/niri-flake/blob/main/docs.md
          mod-key = config.my.desktop.mod_key;
          spawn-at-startup = [
            { argv = [ "swaync" ]; }
            { argv = [ "wbg" "-s" "/home/pgattic/dotfiles/config/wallpaper/wedding_temple.jpg" ]; }
            { argv = [ "waybar" ]; }
            # { argv = [ "ghostty" "--gtk-single-instance=true" "--quit-after-last-window-closed=false" "--initial-window=false" ]; }
          ];
          screenshot-path = "~/screenshots/%Y-%m-%d %H-%M-%S.png";
          environment = {
            ELECTRON_OZONE_PLATFORM_HINT = "auto"; # Prefer Wayland for electron apps (doesn't always work)
            DISPLAY = ":0"; # required for X11 apps to connect to xwayland-satellite properly
          };
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
            warp-mouse-to-focus.enable = true;
            focus-follows-mouse = {
              enable = true;
              max-scroll-amount = "34%";
            };
          };
          gestures.hot-corners.enable = false;
          # recent-windows.enable = false; # This option doesn't exist in the flake yet for some reason
          outputs = { # `niri msg outputs`
            "eDP-1".scale = 1.0;
          };
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
              active.color = "#7fc8ff";
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
            };
          };
          cursor = {
            theme = "Bibata-Modern-Classic";
            size = 24;
            hide-when-typing = true;
            hide-after-inactive-ms = 1000;
          };
          prefer-no-csd = !config.my.desktop.touch_options;
          window-rules = [
            { clip-to-geometry = true; }
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

            "Mod+Return".action.spawn = [ "foot" ];
            # "Mod+Return".action.spawn = [ "ghostty" "--gtk-single-instance=true" ];
            "Mod+N".action.spawn = [ "foot" "nvim" "note.md" ];
            # "Mod+N".action.spawn = [ "ghostty" "--gtk-single-instance=true" "-e" "nvim" "note.md" ];
            # "Mod+T".action.spawn = [ "kitten" "quick-access-terminal" ];
            "Mod+Space".action.spawn = [ "fuzzel" ];
            "Mod+E".action.spawn = [ "dolphin" ];
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
            "Mod+Shift+Ctrl+Right".action .move-column-to-monitor-right = {};
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

            # Quit / power off monitors
            "Mod+Shift+E".action.quit = {};
            "Mod+Shift+P".action.power-off-monitors = {};

            # Disable the keys I only ever hit on accident
            "Home".action.spawn = [];
            "End".action.spawn = [];
            "Page_Up".action.spawn = [];
            "Page_Down".action.spawn = [];
          };
        };
      };
      waybar = {
        enable = true;
        settings = {
          main = {
            layer = "top"; # Waybar at top layer
            # position = "bottom"; # Waybar position (top|bottom|left|right)
            height = 24; # Waybar height (to be removed for auto height)
            # spacing = 4; # Gaps between modules (4px)
            # Choose the order of the modules
            modules-left = ["niri/workspaces" "cpu" "memory" "temperature"];
            modules-center = ["niri/window"];
            modules-right = ["tray" "mpd" "backlight" "pulseaudio" "network" "battery" "battery#bat2" "clock"];
            # Modules configuration
            "niri/workspaces" = {
              disable-scroll = true;
              all-outputs = true;
              warp-on-scroll = false;
            };
            keyboard-state = {
              numlock = true;
              capslock = true;
              format = "{name} {icon}";
              format-icons = {
                locked = "";
                unlocked = "";
              };
            };
            mpd = {
              format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
              format-disconnected = "Disconnected ";
              format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
              unknown-tag = "N/A";
              interval = 5;
              consume-icons.on = " ";
              random-icons = {
                off = "<span color=\"#f53c3c\"></span> ";
                on = " ";
              };
              repeat-icons.on = " ";
              single-icons.on = "1 ";
              state-icons = {
                paused = "";
                playing = "";
              };
              tooltip-format = "MPD (connected)";
              tooltip-format-disconnected = "MPD (disconnected)";
            };
            idle_inhibitor = {
              format = "{icon}";
              format-icons = {
                "activated" = "";
                "deactivated" = "";
              };
            };
            tray = {
              # icon-size = 21;
              spacing = 10;
            };
            clock = {
              timezone = "US/Mountain";
              format = "{:%a %b %d %I:%M %p}";
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
              format-alt = "{:%Y-%m-%d}";
            };
            cpu = {
              interval = 1;
              #format = " {icon0}{icon1}{icon2}{icon3} {usage:>2}%"; # For quad-core CPU
              format = " {icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7} {usage:>2}%"; # For 8-core cpu
              #format = " {icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7}{icon8}{icon9}{icon10}{icon11}{icon12}{icon13}{icon14}{icon15} {usage:>2}%"; # For 16-core cpu
              format-icons = [
                "<span color='#69ff94'>▁</span>" # green
                "<span color='#2aa9ff'>▂</span>" # blue
                "<span color='#f8f8f2'>▃</span>" # white
                "<span color='#f8f8f2'>▄</span>" # white
                "<span color='#ffffa5'>▅</span>" # yellow
                "<span color='#ffffa5'>▆</span>" # yellow
                "<span color='#ff9977'>▇</span>" # orange
                "<span color='#dd532e'>█</span>"  # red
              ];
            };
            memory.format = "  {used:0.1f}G";
            temperature = {
              # thermal-zone = 2;
              # hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
              critical-threshold = 80;
              # format-critical = "{temperatureC}°C {icon}";
              format = "{icon} {temperatureC}°C";
              format-icons = ["" "" ""];
            };
            backlight = {
              # device = "acpi_video1";
              format = "{icon}  {percent}%";
              format-icons = ["" "" "" "" "" "" "" "" ""];
            };
            battery = {
              states = {
                # good = 95;
                warning = 30;
                critical = 15;
              };
              format = "{icon} {capacity}%";
              format-charging = "󰂄 {capacity}%";
              format-plugged = " {capacity}%";
              format-alt = "{icon} {time}";
              #format-good = ""; # An empty format will hide the module
              format-full = "󱟢";
              format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
            };
            "battery#bat2" = {
              bat = "BAT1";
              states = {
                # good = 95;
                warning = 30;
                critical = 15;
              };
              format = "1{icon} {capacity}%";
              format-charging = "1󰂄 {capacity}%";
              format-plugged = "1 {capacity}%";
              format-alt = "1{icon} {time}";
              #format-good = ""; # An empty format will hide the module
              format-full = "1󱟢";
              format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
            };
            bluetooth = {
              format = " {status}";
              format-connected = " {device_alias}";
              format-connected-battery = " {device_alias} {device_battery_percentage}%";
              # format-device-preference = [ "device1"; "device2" ]; # preference list deciding the displayed device
              tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
              tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
              tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
              tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
            };
            network = {
              # interface = "wlp2*"; # (Optional) To force the use of this interface
              format-wifi = "   {essid} ({signalStrength}%)";
              format-ethernet = "{ipaddr}/{cidr} 󱂇";
              tooltip-format = "{ifname} via {gwaddr}";
              format-linked = "{ifname} (No IP) ";
              format-disconnected = "Disconnected ⚠";
              format-alt = "{ifname}: {ipaddr}/{cidr}";
            };
            pulseaudio = {
              # scroll-step = 1; # %; can be a float
              format = "{icon}   {volume}% {format_source}";
              format-bluetooth = "{volume}% {icon} {format_source}";
              format-bluetooth-muted = "󰝟 {icon} {format_source}";
              format-muted = "󰝟  {format_source}";
              format-source = "";
              format-source-muted = "";
              format-icons = {
                headphone = "󰋋 ";
                hands-free = "";
                headset = "󰋋 ";
                phone = "";
                portable = "";
                car = "";
                default = ["" "" ""];
              };
              on-click = "pavucontrol";
            };
          };
        };
        style = ''
          * {
            /* `otf-font-awesome` is required to be installed for icons */
            /* font-family: "JetBrainsMono Nerd Font", FontAwesome, Roboto, Helvetica, Arial, sans-serif; */
            font-size: 12px;
          }

          window#waybar {
            background-color: rgba(17, 17, 17, 0.8);
            color: #ffffff;
            transition-property: background-color;
            transition-duration: .5s;
            margin: 5px;
          }

          window#waybar.hidden {
            opacity: 0.2;
          }

          window#waybar.termite {
            background-color: #3F3F3F;
          }

          window#waybar.chromium {
            background-color: #000000;
            border: none;
          }

          button {
            /* Use box-shadow instead of border so the text isn't offset */
            box-shadow: inset 0 -2px transparent;
            /* Avoid rounded borders under each button name */
            border: none;
            border-radius: 0px;
          }

          #workspaces button {
            padding: 0 5px;
            background-color: transparent;
            color: #ffffff;
          }

          #workspaces button:hover {
            background-color: rgba(0, 0, 0, 0.8);
            box-shadow: inherit;
            text-shadow: inherit;
          }

          #workspaces button.active {
            background-color: rgba(255, 255, 255, 0.15);
          }

          #workspaces button.urgent {
            background-color: #eb4d4b;
          }

          #workspaces button.persistent {
            color: #888888;
          }

          #mode {
            background-color: #64727D;
            border-bottom: 3px solid #ffffff;
          }

          #clock, #battery, #cpu, #memory, #disk, #temperature, #backlight, #network, #pulseaudio, #wireplumber, #custom-media, #tray, #mode, #idle_inhibitor, #scratchpad, #mpd {
            padding: 0 10px;
            color: #ffffff;
          }

          #window,
          #workspaces {
            margin: 0 4px;
          }

          /* If workspaces is the leftmost module, omit left margin */
          .modules-left > widget:first-child > #workspaces {
            margin-left: 0;
          }

          /* If workspaces is the rightmost module, omit right margin */
          .modules-right > widget:last-child > #workspaces {
            margin-right: 0;
          }

          #battery.charging, #battery.plugged {
            background-color: #26A65B;
          }

          @keyframes blink {
            to {
              background-color: rgba(0,0,0,0);
            }
          }

          #battery.critical:not(.charging) {
            background-color: rgba(255, 0, 0, 0.6);
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
          }

          label:focus {
            background-color: #000000;
          }

          #network.disconnected {
            background-color: #f53c3c;
          }

          #wireplumber {
            background-color: #fff0f5;
            color: #000000;
          }

          #wireplumber.muted {
            background-color: #f53c3c;
          }

          #custom-media {
            background-color: #66cc99;
            color: #2a5c45;
            min-width: 100px;
          }

          #custom-media.custom-spotify {
            background-color: #66cc99;
          }

          #custom-media.custom-vlc {
            background-color: #ffa000;
          }

          #temperature.critical {
            background-color: #eb4d4b;
          }

          #tray {
            background-color: #2980b9;
          }

          #tray > .passive {
            -gtk-icon-effect: dim;
          }

          #tray > .needs-attention {
            -gtk-icon-effect: highlight;
            background-color: #eb4d4b;
          }

          #idle_inhibitor {
            background-color: #2d3436;
          }

          #idle_inhibitor.activated {
            background-color: #ecf0f1;
            color: #2d3436;
          }

          #mpd {
            background-color: #66cc99;
            color: #2a5c45;
          }

          #mpd.disconnected {
            background-color: #f53c3c;
          }

          #mpd.stopped {
            background-color: #90b1b1;
          }

          #mpd.paused {
            background-color: #51a37a;
          }

          #language {
            background: #00b093;
            color: #740864;
            padding: 0 5px;
            margin: 0 5px;
            min-width: 16px;
          }

          #keyboard-state {
            background: #97e1ad;
            color: #000000;
            padding: 0 0px;
            margin: 0 5px;
            min-width: 16px;
          }

          #keyboard-state > label {
            padding: 0 5px;
          }

          #keyboard-state > label.locked {
            background: rgba(0, 0, 0, 0.2);
          }

          #scratchpad {
            background: rgba(0, 0, 0, 0.2);
          }

          #scratchpad.empty {
            background-color: transparent;
          }

        '';
      };
      fuzzel = {
        enable = true;
        settings = {
          main = {
            font = "Sans:size=18";
            dpi-aware = false;
            prompt = "🔍 ";
            lines = 8;
            width = 18;
            horizontal-pad = 10;
            vertical-pad = 4;
          };
          colors = {
            background = "222222bb";
            text = "ffffffff";
            selection = "333333dd";
            selection-text = "ffffffff";
            border = "285544ff";
          };
          border = {
            width = 0;
            radius = 0;
          };
        };
      };
    };
  };
}

