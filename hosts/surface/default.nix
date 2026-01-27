{ lib, config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth = { # Cool boot splash screen
    enable = true;
    logo = "${pkgs.nixos-icons}/share/icons/hicolor/128x128/apps/nix-snowflake.png";
  };

  networking.hostName = "surface";
  hardware.bluetooth.enable = true;
  hardware.microsoft-surface.kernelVersion = "stable";

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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.pgattic = {
    isNormalUser = true;
    description = "Preston Corless";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    zed-editor
    ungoogled-chromium
    luanti-client
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  programs = {
    nano.enable = false;
    firefox.enable = true;
    niri = {
      enable = true;
      useNautilus = false;
    };
  };

  services = {
    mullvad-vpn.enable = true;
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

  system.stateVersion = "25.05"; # Do not modify
}

