{ config, pkgs, inputs, ... }: {
  imports = [ ../default.nix ];

  my.desktop = {
    enable = true;
    display_config."eDP-1".scale = 1.0;
  };

  home.packages = with pkgs; [
    zed-editor
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

