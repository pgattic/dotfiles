let opacity = 0.85; in {
  flake = {
    nixosModules.stylix = { pkgs, ... }: {
      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/github-dark.yaml";
        # base16Scheme = {
        #   # Neutrals (background → brightest)
        #   base00 = "1e1e1e";
        #   base01 = "242424"; # panel background
        #   base02 = "2b2b2b"; # alt background
        #   base03 = "595959"; # muted text
        #   base04 = "8e8e8e"; # border-ish
        #   base05 = "cccccc"; # main fg
        #   base06 = "dedede"; # brighter fg
        #   base07 = "ffffff"; # highlight fg
        #
        #   base08 = "cd3131"; # red
        #   base09 = "f14c4c"; # orange
        #   base0A = "e5e510"; # yellow
        #   base0B = "0dbc79"; # green
        #   base0C = "11a8cd"; # cyan
        #   base0D = "2472c8"; # blue
        #   base0E = "bc3fbc"; # magenta
        #   base0F = "d670d6"; # extra / misc
        # };

        targets.plymouth.enable = false;
      };
    };
    homeModules.stylix = { pkgs, ... }: {
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
        opacity = {
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

