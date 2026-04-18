{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.t480 = withSystem "x86_64-linux" ({ self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
      inputs.self.nixosModules.options
      inputs.self.nixosModules.default
      inputs.self.nixosModules.desktop-default
      inputs.self.nixosModules.stylix
      inputs.self.nixosModules.work
      inputs.self.nixosModules.zeditor
      inputs.self.nixosModules.browser
      inputs.self.nixosModules.office
      inputs.self.nixosModules.obsidian

      ({ pkgs, ... }: {
        networking.hostName = "t480";
        system.stateVersion = "25.05";

        zramSwap.enable = false; # This machine has a swap partition

        environment.systemPackages = with pkgs; [
          self'.packages.foot-rude
          pinta
          antigravity-fhs
          self'.packages.luanti-client
          zoom-us
          ventoy
          signal-desktop
          whatsapp-electron
          zotero
          vesktop
          element-desktop
          ungoogled-chromium
          ripgrep-all
          kdeconnect
          self'.packages.bambu-studio
          self'.packages.jujutsu
          inputs.wasmcarts.packages.${stdenv.hostPlatform.system}.engine-linux
          self'.packages.desktop
          self'.packages.sioyek
          self'.packages.neovim # The package provides aliases
          self'.packages.btop
          self'.packages.git
        ];

        programs = {
          nix-ld.enable = true;
          appimage.enable = true;
          appimage.binfmt = true;
          niri = {
            enable = true;
            useNautilus = false;
            package = (self'.packages.niri-activate-linux.apply {
              settings.outputs."eDP-1".scale = 1.0;
            }).wrapper;
          };
        };

        services = {
          mullvad-vpn.enable = true;
        };
      })
    ];
  });
}

