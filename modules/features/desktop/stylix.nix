{ inputs, ... }: let
  hmModule = { config, lib, pkgs, ... }: {
    imports = [
      inputs.stylix.homeModules.stylix # https://github.com/sodiboo/niri-flake
    ];

    home.packages = with pkgs; [
      adwaita-qt
      adwaita-qt6
    ];
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/github-dark.yaml";
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
      };
      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };
        sizes.terminal = 10;
      };
      icons = {
        enable = true;
        package = pkgs.papirus-icon-theme;
        dark = "Papirus-Dark";
        light = "Papirus-Light";
      };
      polarity = "dark";
      opacity = let
        # Fix for Niri's window handling
        opacity = if config.my.desktop.touch_options then 1.0 else config.my.desktop.opacity;
      in {
        applications = opacity;
        desktop = opacity;
        popups = opacity;
        terminal = opacity;
      };
      targets.neovim.enable = false;
      targets.gnome.enable = lib.mkDefault false; # This is broken for now, but doesn't affect me
    };

    # qt = {
    #   enable = true;
    #   # style.name = "adwaita";
    # };
  };
in {
  flake = {
    nixosModules.stylix = { config, pkgs, ... }: {
      home-manager.users.${config.my.user.name} = hmModule;
      stylix = {
        enable = true;
        homeManagerIntegration.autoImport = false;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/github-dark.yaml";
        targets.plymouth.enable = false;
      };
    };
    homeModules.stylix = hmModule;
  };
}

