{ inputs, ... }: {
  perSystem = { pkgs, ... }: let
    wlib = inputs.nix-wrapper-modules.lib;
  in {
    packages = {
      btop = wlib.evalPackage {
        inherit pkgs;
        imports = [ wlib.wrapperModules.btop ];
        settings = {
          theme_background = false;
          vim_keys = true;
          proc_gradient = false;
          proc_filter_kernel = true;
        };
      };
      fastfetch = wlib.evalPackage {
        inherit pkgs;
        imports = [ wlib.wrapperModules.fastfetch ];
        settings = {
          logo = "NixOS";
          "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json";
          modules = [
            "title"
            "separator"
            "os" "host" "kernel"
            "uptime"
            "packages"
            "shell"
            "display"
            "de" "wm"
            "terminal" "terminalfont"
            "cpu" "gpu" "memory" "swap" "disk"
            "localip"
            "battery"
            "poweradapter"
            "break"
            "colors"
          ];
        };
      };
      git = wlib.evalPackage {
        inherit pkgs;
        imports = [ wlib.wrapperModules.git ];
        settings = {
          user.name = "pgattic";
          user.email = "pgattic@gmail.com";
          color.ui = "auto";
          init.defaultBranch = "master";
        };
      };
      jujutsu = wlib.evalPackage {
        inherit pkgs;
        imports = [ wlib.wrapperModules.jujutsu ];
        settings = {
          user.name = "pgattic";
          user.email = "pgattic@gmail.com";
          ui = {
            default-command = [ "log" "--reversed" ];
            paginate = "never";
          };
        };
      };
      nh = wlib.wrapPackage ({ config, ... }: {
        inherit pkgs;
        package = pkgs.nh;
        env.NH_FLAKE = "/home/pgattic/dotfiles";
      });
      sioyek = wlib.wrapPackage ({ config, ... }: {
        inherit pkgs;
        package = pkgs.sioyek;
        env.XDG_CONFIG_HOME = "${builtins.placeholder "out"}/config";
        constructFiles.sioyekPrefs = {
          relPath = "config/sioyek/prefs_user.config";
          content = ''
            background_color #161b22
            custom_background_color #161b22
            custom_text_color #c9d1d9
            highlight_color_a #bb8009
            highlight_color_b #2ea043
            highlight_color_c #388bfd
            highlight_color_d #f85149
            highlight_color_e #a371f7
            highlight_color_f #db6d28
            highlight_color_g #bb8009
            link_highlight_color #388bfd
            search_highlight_color #bb8009
            should_highlight_unselected_search 1
            startup_commands toggle_custom_color
            status_bar_color #30363d
            status_bar_text_color #c9d1d9
            super_fast_search 0
            synctex_highlight_color #2ea043
            text_highlight_color #bb8009
            ui_background_color #30363d
            ui_selected_background_color #484f58
            ui_selected_text_color #c9d1d9
            ui_text_color #c9d1d9
            # visual_mark_color #484f58
          '';
        };
      });
      zellij = wlib.wrapPackage ({ config, ... }: { # Zellij doesn't have a pre-built module
        inherit pkgs;
        package = pkgs.zellij;
        constructFiles.zellijConfig = {
          relPath = "config.kdl";
          content = ''
            show_startup_tips false
          '';
        };
        flags."--config" = config.constructFiles.zellijConfig.path;
      });
    };
  };
}

