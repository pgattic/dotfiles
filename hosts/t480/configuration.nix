# `man configuration.nix 5`, `nixos-help`
{ lib, config, optins, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "uinput" ];
  boot.plymouth = { # Cool boot splash screen
    enable = true;
    logo = "${pkgs.nixos-icons}/share/icons/hicolor/128x128/apps/nix-snowflake.png";
  };

  networking.hostName = "t480";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  hardware.bluetooth.enable = true;

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
    packages = with pkgs; [
    ];
  };

  hardware.uinput.enable = true; # Added alongside the "dialout" user group for work

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = ["root" "pgattic"];
  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-1.1.07"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    helix # Terminal editor that I can't seem to get the hang of

    # Desktop
    kitty
    ghostty
    alacritty
    foot
    ironbar
    zed-editor
    libnotify
    mcpelauncher-ui-qt
    discord
    obsidian
    nwg-look
    slack
    ungoogled-chromium
    qbittorrent
    bambu-studio
    nicotine-plus # Soulseek client
    pinta


    luanti-client
    prismlauncher
    # antimicrox
    # calibre

    vscode
    zoom-us
    ventoy

    waypipe
    signal-desktop
    openscad
    freecad
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    material-symbols
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

  # Android Development
  virtualisation.docker.enable = true;
  programs.adb.enable = true;

  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE  = "24";
    EDITOR = "nvim";
  };

  environment.sessionVariables = {
    NH_OS_FLAKE = "/home/pgattic/dotfiles";
    GTK_USE_PORTAL = "1";
    NIXOS_OZONE_WL = "1";
    XDG_CURRENT_DESKTOP = "GNOME"; # cap
    XDG_SESSION_DESKTOP = "niri";
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

  # Do not modify
  system.stateVersion = "25.05";
}

