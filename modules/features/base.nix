{ config, lib, ... }: {
  flake = {
    nixosModules.base = { pkgs, ... }: {
      nixpkgs.overlays = import ../../overlays;

      time.timeZone = "America/Boise";
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };

      nix.settings = {
        experimental-features = [ "nix-command" "flakes" ];
        trusted-users = ["root" config.my.user.name];
      };

      nixpkgs.config.allowUnfree = true;

      nixpkgs.config.permittedInsecurePackages = [
        "ventoy-1.1.10"
      ];

      programs.nano.enable = false;

      services.fwupd.enable = true;

      environment.sessionVariables = {
        NH_OS_FLAKE = "${config.my.user.home_dir}/dotfiles";
      };

      systemd.services.speech-dispatcher.wantedBy = pkgs.lib.mkForce []; # Don't need speech dispatcher
      systemd.services.NetworkManager-wait-online.enable = false; # Don't require internet connection on boot
    };

    homeModules.base = { pkgs, ... }: {
      home.packages = with pkgs; [
        (lib.hiPrio uutils-coreutils-noprefix) # uutils preferred over GNU coreutils
        openssh_hpn # SSH but faster
        usbutils
        ripgrep
        bat
        gdu
        less
        file
        tree
        ouch # Archive manager
        jq
        tinyxxd

        nil # Nix language server
        nix-output-monitor # provides `nom` as a cooler replacement for `nix` commands
      ];


      programs = {
        home-manager.enable = true;
        btop = {
          enable = true;
          settings = {
            theme_background = false;
            vim_keys = true;
            proc_gradient = false;
            proc_filter_kernel = true;
          };
        };
        nh.enable = true;
        zellij = {
          enable = true;
          settings = {
            show_startup_tips = false;
          };
        };
        fastfetch = {
          enable = true;
          settings = {
            "logo" = "NixOS";
            "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json";
            "modules" = [
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
      };
    };
  };
}

