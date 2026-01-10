{ config, pkgs, inputs, ... }: {
  imports = [ ../default.nix ];

  # xdg.configFile."niri" = {
  #   source = ../config/niri;
  #   recursive = true;
  # };

  home.packages = with pkgs; [
    wl-clipboard-rs

    wf-recorder
    wl-mirror
    waybar
    fuzzel
    swaynotificationcenter
    wbg
    pavucontrol
    overskride # Bluetooth manager
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
  ];

  programs = {
    foot = {
      enable = true;
    };
  };

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.stateVersion = "25.11"; # Don't
}

