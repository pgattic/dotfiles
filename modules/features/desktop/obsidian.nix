{
  flake = {
    nixosModules.obsidian = { ... }: {};
    homeModules.obsidian = { ... }: {

      stylix.targets.obsidian = {
        vaultNames = [ "obsidian" ];
        fonts.override.sizes.applications = 16; # It was 12 by default
      };

      programs.obsidian = {
        enable = true;
        defaultSettings.app = {
          vimMode = true;
          showInlineTitle = false;
        };
      };
    };
  };
}

