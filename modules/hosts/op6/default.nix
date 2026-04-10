{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.op6 = withSystem "aarch64-linux" ({ pkgs, self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      (import "${inputs.mobile-nixos}/lib/configuration.nix" { device = "oneplus-enchilada"; })

      ({ config, lib, pkgs, ... }: {
        networking.hostName = "op6";
        system.stateVersion = "26.05";

        nixpkgs.config.allowUnfree = true;
        hardware.bluetooth.enable = false;

        services.openssh.enable = true;
        services.openssh.settings.PermitRootLogin = "yes"; # For initial setup
        services.openssh.settings.PasswordAuthentication = true; # For initial setup

        # COPIED FROM MY NETWORKING MODULE
        networking.networkmanager.enable = lib.mkDefault true;
        networking.networkmanager.dns = "none";
        networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
        # COPIED FROM MY NETWORK MODULE

        # PipeWire is enabled by default, but the audio is very quiet with it
        services.pipewire.enable = lib.mkForce false;
        # Make sure to select "Speakers Output" as the output device in the settings
        services.pulseaudio.enable = true;

        users.users.pgattic = {
          isNormalUser = true;
          extraGroups = [ "wheel" "networkmanager" ];
          description = "Preston Corless";
          shell = self'.packages.nushell-env;
        };

        services.displayManager.gdm.enable = true;

        environment.systemPackages = [
          self'.packages.foot-rude
          self'.packages.luanti-client
          # self'.packages.desktop
        ];

        programs = {
          git = {
            enable = true;
            package = self'.packages.git;
          };
          niri = {
            enable = true;
            useNautilus = false;
            package = self'.packages.niri-mobile;
          };
        };
      })
    ];
  });
}

