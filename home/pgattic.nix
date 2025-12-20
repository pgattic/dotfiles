{ config, pkgs, inputs, ... }: {

  home.username = "pgattic";
  home.homeDirectory = "/home/pgattic";

  home.packages = with pkgs; [
    (lib.hiPrio uutils-coreutils-noprefix) # uutils preferred over GNU coreutils
    neovim gcc # Tree-sitter requires a C compiler
    usbutils
    nushell
    btop
    ripgrep
    bat
    wl-clipboard-rs
    gdu
    less
    file
    tree
    fastfetch
    ouch # Archive manager
    jq
    tinyxxd
    nh
    nix-output-monitor # provides `nom` as a cooler replacement for `nix` commands

    wf-recorder
    wl-mirror # Thought I didn't need this, but then I had to go ahead and switch to Niri...
    waybar
    fuzzel
    lazygit
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
    git = {
      enable = true;
      settings = {
        user.name = "pgattic";
        user.email = "pgattic@gmail.com";
        color.ui = "auto";
        init.defaultBranch = "master";
      };
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

  home.sessionVariables = { # For terminal shells, not for the desktop
    EDITOR = "nvim";
  };

  home.stateVersion = "25.11"; # Don't
  programs.home-manager.enable = true;
}

