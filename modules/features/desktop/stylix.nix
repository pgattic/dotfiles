inputs: {
  flake = {
    nixosModules.stylix = { config, pkgs, ... }: {
      home-manager.users.${config.my.user.name}.imports = [
        inputs.config.flake.homeModules.stylix
      ];
      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/github-dark.yaml";
        targets.plymouth.enable = false;
      };
    };
    homeModules.stylix = { osConfig, pkgs, ... }: {
      home.packages = with pkgs; [
        adwaita-qt
        adwaita-qt6
      ];
      stylix = {
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
          opacity = if osConfig.my.desktop.touch_options then 1.0 else osConfig.my.desktop.opacity;
        in {
          applications = opacity;
          desktop = opacity;
          popups = opacity;
          terminal = opacity;
        };
        targets.neovim.enable = false;
      };

      # qt = {
      #   enable = true;
      #   # style.name = "adwaita";
      # };
    };
  };
}

