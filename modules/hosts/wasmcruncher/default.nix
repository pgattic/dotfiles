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
        # my.desktop.corner_radius = 40.0; # Example of modifying a config value
        home.packages = with pkgs; [
          zotero
        ];
      })
    ];
  };
}

