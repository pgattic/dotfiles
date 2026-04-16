let
  hmModule = { ... }: {
    programs.obsidian = {
      enable = true;
      defaultSettings.app = {
        vimMode = true;
        showInlineTitle = false;
      };
    };
  };
in {
  flake = {
    nixosModules.obsidian = { config, ... }: {
      home-manager.users.${config.my.user.name} = hmModule;
    };
    homeModules.obsidian = hmModule;
  };
}

