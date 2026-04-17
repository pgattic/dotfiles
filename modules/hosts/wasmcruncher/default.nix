{ config, inputs, ... }: {
  flake.homeConfigurations."pgattic@wasmcruncher" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };

    modules = [
      config.flake.homeModules.options
      config.flake.homeModules.default
      config.flake.homeModules.desktop-default
      config.flake.homeModules.browser

      ({ pkgs, ... }: {
        targets.genericLinux.enable = true;
        home.packages = with pkgs; [
          self'.packages.foot-rude
          zotero
        ];
      })
    ];
  };
}

