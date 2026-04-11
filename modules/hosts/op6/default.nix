{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.op6 = withSystem "aarch64-linux" ({ pkgs, self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      (import "${inputs.mobile-nixos}/lib/configuration.nix" { device = "oneplus-enchilada"; })

      ({ config, lib, pkgs, ... }: {
        networking.hostName = "op6";
        system.stateVersion = "26.05";

        services.logind.settings.Login = {
          HandlePowerKey = "ignore"; # The kernel handles this already
          HandlePowerKeyLongPress = "poweroff";
        };

        nixpkgs.config.allowUnfree = true;
        hardware.bluetooth = {
          enable = true;
          powerOnBoot = false;
          settings.General.Experimental = true;
        };

        services.openssh.enable = true;
        services.openssh.settings.PasswordAuthentication = true; # For initial setup

        # COPIED FROM MY NETWORKING MODULE
        networking.networkmanager.enable = lib.mkDefault true;
        networking.networkmanager.dns = "none";
        networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
        # COPIED FROM MY NETWORK MODULE

        # COPIED FROM MY BASE MODULE
        time.timeZone = "America/Boise";
        nix.settings = {
          experimental-features = [ "nix-command" "flakes" ];
          trusted-users = ["root" "@wheel" ];
        };
        programs.nano.enable = false;
        services.openssh.package = pkgs.openssh_hpn;
        documentation.enable = lib.mkDefault false; # Disable all documentation
        systemd.services.speech-dispatcher.wantedBy = pkgs.lib.mkForce []; # Don't need speech dispatcher
        systemd.services.NetworkManager-wait-online.enable = false; # Don't require internet connection on boot
        # COPIED FROM MY BASE MODULE

        services.upower.enable = true;

        users.users.pgattic = {
          isNormalUser = true;
          extraGroups = [ "wheel" "networkmanager" "input" ];
          description = "Preston Corless";
          shell = self'.packages.nushell-env;
        };

        services.displayManager.gdm.enable = true;

        environment.systemPackages = [
          self'.packages.foot-rude
          self'.packages.luanti-client
          self'.packages.desktop
          pkgs.signal-desktop
          pkgs.ungoogled-chromium
        ];

        programs = {
          git = {
            enable = true;
            package = self'.packages.git;
          };
          niri = {
            enable = true;
            useNautilus = false;
            package = (self'.packages.niri-mobile.apply {
              settings = {
                outputs."DSI-1".scale = 2.0;
              };
            }).wrapper;
          };
          lazygit.enable = true;
        };
      })
    ];
  });
}

