{ inputs, ... }: {
  perSystem = { pkgs, self', ... }: let
    wlib = inputs.nix-wrapper-modules.lib;

    foot-base = wlib.evalModule ({
      inherit pkgs;
      imports = [ wlib.wrapperModules.foot ];
      env.FONTCONFIG_FILE = pkgs.makeFontsConf {
        fontDirectories = [ "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype" ];
      };
      filesToExclude = [ # Remove foot's client/server stuff
        "bin/footclient"
        "lib/systemd/user/*"
        "share/systemd/user/*"
        "share/applications/foot-server.desktop"
        "share/applications/footclient.desktop"
      ];
      settings = {
        main = {
          dpi-aware = "no";
          font = "JetBrainsMono Nerd Font:size=10";
          initial-color-theme = "dark";
          resize-delay-ms = 0;
          term = "xterm-256color";
        };
        cursor = {
          style = "beam";
          blink = true;
        };
        csd = {
          font = "Sans:size=10";
          color = "333333";
          button-color = "ffffff";
        };
        mouse-bindings.primary-paste = "none";
        colors-dark = {
          alpha = 0.85;
          background = "161b22";
          foreground = "c9d1d9";
          "16" = "db6d28";
          "17" = "3d2f00";
          "18" = "30363d";
          "19" = "484f58";
          "20" = "8b949e";
          "21" = "f0f6fc";
          regular0 = "161b22";
          regular1 = "f85149";
          regular2 = "2ea043";
          regular3 = "bb8009";
          regular4 = "388bfd";
          regular5 = "a371f7";
          regular6 = "2a9d9a";
          regular7 = "c9d1d9";
          bright0 = "6e7681";
          bright1 = "f85149";
          bright2 = "2ea043";
          bright3 = "bb8009";
          bright4 = "388bfd";
          bright5 = "a371f7";
          bright6 = "2a9d9a";
          bright7 = "ffffff";
        };
      };
    });

    foot = foot-base.config.apply ({ lib, ... }: {
      env.SHELL = lib.getExe self'.packages.nushell-env;
    });

    foot-rude = foot-base.config.apply ({ lib, ... }: {
      env.SHELL = lib.getExe self'.packages.nushell-env-rude;
    });
  in {
    packages = {
      foot-base = foot-base.config.wrapper;
      foot = foot.wrapper;
      foot-rude = foot-rude.wrapper;
    };
  };
}

