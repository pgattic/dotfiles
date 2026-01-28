# `man configuration.nix 5`, `nixos-help`
{ lib, config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "uinput" ];
  boot.plymouth.enable = true;

  networking.hostName = "t480";
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings.General.Experimental = true;
  };

  networking.networkmanager.enable = true;

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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
    config.common.default = [
      "wlr"
      "gtk"
    ];
    xdgOpenUsePortal = true;
  };
  # services.xdg-desktop-portal.enable = true;
  # services.xdg-desktop-portal.backends = [ pkgs.xdg-desktop-portal-gtk ];

  users.users.pgattic = {
    isNormalUser = true;
    description = "Preston Corless";
    extraGroups = [
      "networkmanager"
      "wheel"
      "kvm"
      "adbusers"
      "docker"
      "input"
      "dialout"
    ];
    shell = pkgs.nushell;
  };

  hardware.uinput.enable = true; # Added alongside the "dialout" user group for work

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = ["root" "pgattic"];
  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-1.1.10"
  ];

  programs = {
    nano.enable = false; # `true` should not have been the default

    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [
      wayland
      wayland-protocols
    ];

    kdeconnect.enable = true;

    niri = {
      enable = true;
      useNautilus = false; # Silly default options
    };

    thunar.enable = true;
    xfconf.enable = true; # XFCE configuration storage

    appimage.enable = true;
    appimage.binfmt = true;

    firefox = {
      enable = true;
      # policies = {
      #   ExtensionSettings = {
      #
      #   }
      # };
      preferences = {
        "browser.gesture.swipe.left" = "cmd_scrollLeft";
        "browser.gesture.swipe.right" = "cmd_scrollRight";
        "browser.uiCustomization.state" = ''
          {
            "placements": {
              "widget-overflow-fixed-list": [],
              "unified-extensions-area": [],
              "nav-bar": [
                "back-button",
                "forward-button",
                "stop-reload-button",
                "customizableui-special-spring1",
                "vertical-spacer",
                "urlbar-container",
                "customizableui-special-spring2",
                "downloads-button",
                "unified-extensions-button"
              ],
              "toolbar-menubar": [
                "menubar-items"
              ],
              "TabsToolbar": [
                "tabbrowser-tabs",
                "new-tab-button"
              ],
              "vertical-tabs": [],
              "PersonalToolbar": [
                "import-button",
                "personal-bookmarks"
              ]
            },
            "seen": [
              "developer-button",
              "screenshot-button"
            ],
            "dirtyAreaCache": [
              "nav-bar",
              "vertical-tabs",
              "toolbar-menubar",
              "TabsToolbar",
              "PersonalToolbar"
            ],
            "currentVersion": 23,
            "newElementCount": 4
          }
        '';
      };
    };
  };

  # Virt-manager config
  # programs.virt-manager.enable = true;
  # users.groups.libvirtd.members = [ "pgattic" ];
  # virtualisation.libvirtd = {
  #   enable = true;
  #   qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
  #   qemu.ovmf.enable = true;
  # };
  # virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.docker.enable = true;

  environment.sessionVariables = {
    GTK_USE_PORTAL = "1";
    NIXOS_OZONE_WL = "1";
  };

  services = {
    fwupd.enable = true; # Firmware update manager
    upower.enable = true;
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = ''
            ${pkgs.tuigreet}/bin/tuigreet --remember --asterisks --time \
            --time-format "%a %b %d %I:%M %p" \
            --window-padding 2 \
            --theme "border=cyan;action=cyan;time=cyan;button=gray"
          '';
          user = "greeter";
        };
      };
    };
    gvfs.enable = true; # Automatic drive mounting, network shares, recycle bin
    flatpak.enable = true; # Only good source for Zen Browser
    syncthing = {
      enable = true;
      user = "pgattic";
      openDefaultPorts = true;
      dataDir = "/home/pgattic";
    };
    udisks2.enable = true; # For Calibre to access plugged-in devices
    mullvad-vpn.enable = true;
  };

  systemd.services.speech-dispatcher.wantedBy = pkgs.lib.mkForce []; # Don't need speech dispatcher
  systemd.services.NetworkManager-wait-online.enable = false; # Don't require internet connection on boot

  stylix = {
    enable = true;
    base16Scheme = {
      # Neutrals (background → brightest)
      base00 = "1e1e1e";
      base01 = "242424"; # panel background
      base02 = "2b2b2b"; # alt background
      base03 = "595959"; # muted text
      base04 = "8e8e8e"; # border-ish
      base05 = "cccccc"; # main fg
      base06 = "dedede"; # brighter fg
      base07 = "ffffff"; # highlight fg

      base08 = "cd3131"; # red
      base09 = "f14c4c"; # orange
      base0A = "e5e510"; # yellow
      base0B = "0dbc79"; # green
      base0C = "11a8cd"; # cyan
      base0D = "2472c8"; # blue
      base0E = "bc3fbc"; # magenta
      base0F = "d670d6"; # extra / misc
    };

    targets.plymouth.enable = false;
  };

  # Do not modify
  system.stateVersion = "25.05";
}

