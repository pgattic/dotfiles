let
  desktopEntries = [ "onlyoffice-desktopeditors.desktop" ];
  hmModule = {
    programs.onlyoffice = {
      enable = true;
      settings = {
        # TODO: report that home-manager has this wrong.
        # These items should be beneath `[General]` in the config file
        UITheme = "theme-night";
        titlebar = "custom"; # Enable client-side decorations (use "system" to do server-side)
        editorWindowMode = true; # Each document gets its own separate window
      };
    };
    xdg.mimeApps.defaultApplications = {
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = desktopEntries;
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = desktopEntries;
      "application/vnd.openxmlformats-officedocument.presentationml.presentation" = desktopEntries;
      "application/msword" = desktopEntries;
      "application/vnd.ms-excel" = desktopEntries;
      "application/vnd.ms-powerpoint" = desktopEntries;
      # "application/pdf" = desktopEntries;
    };
  };
in {
  flake = {
    nixosModules.office = { config, ... }: {
      home-manager.users.${config.my.user.name}.imports = [ hmModule ];
    };
    homeModules.office = hmModule;
  };
}

