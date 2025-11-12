{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  hardware.raspberry-pi."4".fkms-3d.enable = true;
  hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ mesa.drivers ];
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
    packages = with pkgs; [ ];
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [ "root" "pgattic" ];
  };

  environment.systemPackages = with pkgs; [
    git
    tree
    neovim
    gcc
    tmux
    nushell
    btop
    ripgrep
    bat
    wl-clipboard-rs
    less
    file
    fastfetch
    ouch
    wl-mirror
    kitty
    alacritty
    waybar
    fuzzel
    lazygit
    swaynotificationcenter
    wbg
    pavucontrol
    imv
    mpv
    bibata-cursors
    nwg-look
    papirus-icon-theme
    xwayland-satellite
    luanti-client

    nh
    nix-output-monitor # provides `nom` as a cooler replacement for `nix` commands
    nvd
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  programs = {
    niri.enable = true;
    firefox.enable = true;
    thunar.enable = true;
    xfconf.enable = true;
  };
  
  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
    EDITOR = "nvim";
  };

  environment.sessionVariables = {
    NH_FLAKE = "/home/pgattic/dotfiles";
  };

  services = {
    openssh.enable = true;
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

  # networking.firewall.allowedTCPPorts = [ ];
  # networking.firewall.allowedUDPPorts = [ ];

  # Copy the NixOS configuration file and link it from the resulting system (/run/current-system/configuration.nix).
  # system.copySystemConfiguration = true;

  system.stateVersion = "25.05"; # Do not modify
}

