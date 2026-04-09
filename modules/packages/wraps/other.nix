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
        env.NH_FLAKE = "$HOME/dotfiles";
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

