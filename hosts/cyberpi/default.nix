{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  hardware.raspberry-pi."4".fkms-3d.enable = true; # display output
  hardware.raspberry-pi."4".touch-ft5406.enable = true; # touchscreen input
  hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ mesa ];
  };

  hardware.deviceTree.enable = true;

  networking.hostName = "cyberpi"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "America/Boise";

  # hardware.bluetooth = {
  #   enable = true;
  #   powerOnBoot = true;
  # };

  users.users.pgattic = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = [];
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [ "root" "pgattic" ];
  };
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    luanti-client
    ungoogled-chromium
  ];

  programs = {
    niri = {
      enable = true;
      useNautilus = false;
    };
    firefox.enable = true;
    thunar.enable = true;
    xfconf.enable = true;
  };
  
  services = {
    # libinput.enable = true;
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
    gvfs.enable = true;
  };

  systemd.services.speech-dispatcher.wantedBy = pkgs.lib.mkForce []; # No speech dispatcher
  systemd.services.NetworkManager-wait-online.enable = false;

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

