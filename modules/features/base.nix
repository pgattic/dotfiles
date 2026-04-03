{ inputs, ... }: let
  nixpkgsConf = {
    overlays = [
      inputs.nur.overlays.default # Nix User Repository
      (import ../../overlays/bambu-studio.nix)
      ((import ../../overlays/dark-text.nix) inputs.dark-text-src)
      (import ../../overlays/luanti-client.nix)
      (import ../../overlays/mineclonia-game.nix)
      (import ../../overlays/wvkbd-deskintl.nix)
    ];
    config.allowUnfree = true;
    config.permittedInsecurePackages = [
      "ventoy-1.1.10"
    ];
  };
  hmModule = { pkgs, ... }: {
    nixpkgs = nixpkgsConf;
    home.packages = with pkgs; [
      usbutils
      gdu
      file
      tree
      ouch # Archive manager
      tinyxxd

      nil # Nix language server
      nix-output-monitor # provides `nom` as a cooler replacement for `nix` commands
    ];

    programs = {
      home-manager.enable = true;
      nh.enable = true;
      bat.enable = true;
      ripgrep.enable = true;
      less.enable = true;
      jq.enable = true;
      ssh = {
        enable = true;
        package = pkgs.openssh_hpn;
        enableDefaultConfig = false; # Will apparently be deprecated soon
      };
      btop = {
        enable = true;
        settings = {
          theme_background = false;
          vim_keys = true;
          proc_gradient = false;
          proc_filter_kernel = true;
        };
      };
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
    home.stateVersion = "25.05";
  };
in {
  flake = {
    nixosModules.base = { config, lib, pkgs, ... }: {
      imports = [
        inputs.stylix.nixosModules.stylix
        inputs.home-manager.nixosModules.home-manager
      ];
      nixpkgs = nixpkgsConf;

      boot.loader.systemd-boot.enable = lib.mkDefault true;
      # Allow NixOS to add itself to bootloader options
      boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

      home-manager = {
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs; };
        users.${config.my.user.name} = hmModule;
      };

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
        trusted-users = ["root" "@wheel" ];
      };

      programs.nano.enable = false;

      services = {
        fwupd.enable = lib.mkDefault true;
        openssh.package = pkgs.openssh_hpn;
      };

      environment.sessionVariables = {
        NH_OS_FLAKE = "${config.my.user.home_dir}/dotfiles";
      };

      # documentation.enable = lib.mkDefault false; # Disable all documentation
      systemd.services.speech-dispatcher.wantedBy = pkgs.lib.mkForce []; # Don't need speech dispatcher
      systemd.services.NetworkManager-wait-online.enable = false; # Don't require internet connection on boot
    };
    homeModules.base = hmModule;
  };
}

