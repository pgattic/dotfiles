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
        opacity = 0.85;
      in {
        applications = opacity;
        desktop = opacity;
        popups = opacity;
        terminal = opacity;
      };
      targets = {
        neovim.enable = false;
        blender.enable = lib.mkDefault false; # enabled by default for some reason
        gnome.enable = lib.mkDefault false; # This is broken for now, but doesn't affect me
        obsidian = {
          vaultNames = [ "obsidian" ];
          fonts.override.sizes.applications = 16; # It was 12 by default
        };
        librewolf = {
          profileNames = [ config.my.user.name ];
          colorTheme.enable = true;
        };
      };
    };

    # qt = {
    #   enable = true;
    #   # style.name = "adwaita";
    # };
  };
in {
  flake = {
    nixosModules.stylix = { config, pkgs, ... }: {
      imports = [ inputs.stylix.nixosModules.stylix ];
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

