{ inputs, ... }: {
  perSystem = { pkgs, self', ... }: let
    wlib = inputs.nix-wrapper-modules.lib;

    nushell = wlib.evalModule ({
      inherit pkgs;
      imports = [ wlib.wrapperModules.nushell ];
      "config.nu".content = ''
        $env.config = {
          buffer_editor: "nvim",
          show_banner: false,
          filesize: {
            unit: "binary",
          }
          history: {
            file_format: 'sqlite',
            isolation: true,
          }
          completions: {
            case_sensitive: true,
          }
        }
      '';
    });

    nushell-env = nushell.config.apply ({ lib, ... }: {
      "config.nu".content = lib.mkAfter ''
        open --raw "${../../../assets}/torterra.txt" | print
        $"Uptime: (ansi green_bold)((sys host).uptime)(ansi reset)" | print
        $"Memory used: (ansi green_bold)(sys mem | get used)(ansi reset)/(ansi green_bold)(sys mem | get total)(ansi reset)" | print
        "\"You are nothing but an unreliable wizard\" - Bruce Webster" | print
      '';
      env.EDITOR = lib.getExe self'.packages.neovim;
      extraPackages = [
        self'.packages.neovim

        pkgs.usbutils
        pkgs.gdu
        pkgs.file
        pkgs.tree
        pkgs.ouch # Archive manager
        pkgs.tinyxxd
      ];
    });

    nushell-env-rude = nushell-env.apply ({ lib, ... }: {
      "config.nu".content = lib.mkAfter ''
        $env.config.hooks.command_not_found = { |cmd: string|
          print "You stupid idiot"
          job spawn { ${self'.packages.dark-text}/bin/dark-text -t "RETARD" --duration 2000 }
        }
      '';
    });
  in {
    packages = {
      nushell = nushell.config.wrapper;
      nushell-env = nushell-env.wrapper;
      nushell-env-rude = nushell-env-rude.wrapper;
    };
  };
}

