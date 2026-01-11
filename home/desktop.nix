{ config, lib, pkgs, inputs, ... }: {

  options.my.desktop = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable the desktop configurations and packages";
    };

    enable_bluetooth = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable Bluetooth-related applications/configs";
    };

    # cpu_cores = mkOption {
    #   type = types.int;
    #   default = 8;
    #   description = "Number of CPU cores (used by Waybar module)";
    # };
    #
    # mod_key = mkOption {
    #   type = types.enum [ "Super" "Alt" ];
    #   default = "Super";
    #   description = "Mod key to use for main desktop navigation (used by Niri module)";
    # };
  };

  config = lib.mkIf config.my.desktop.enable {
    home.packages = with pkgs; [
      wl-clipboard-rs

      wf-recorder
      wl-mirror
      waybar
      fuzzel
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
      };
    };
  };
}

