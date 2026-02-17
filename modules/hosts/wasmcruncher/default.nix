{ inputs, ... }: {
  flake.homeConfigurations.wasmcruncher = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };

    modules = [
      inputs.self.homeModules.default
      inputs.self.homeModules.desktop-default

      {
        targets.genericLinux.enable = true;
      }
    ];
  };
}

