{ config, pkgs, inputs, ... }: {
  imports = [ ../default.nix ];

  my.desktop = {
    enable = true;
    enable_bluetooth = true;
    cpu_cores = 8;
    display_config."eDP-1".scale = 1.0;
  };

  home.packages = with pkgs; [
    # Desktop
    kitty
    ghostty
    alacritty
    zed-editor
    libnotify
    mcpelauncher-ui-qt
    discord
    obsidian
    slack
    ungoogled-chromium
    qbittorrent
    bambu-studio
    nicotine-plus # Soulseek client
    pinta
    antigravity-fhs

    luanti-client
    prismlauncher
    # antimicrox
    calibre

    vscode
    zoom-us
    ventoy

    waypipe
    signal-desktop
    openscad
  ];

  programs = {
    helix.enable = true;
  };
}

