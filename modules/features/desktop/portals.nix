{
  flake = {
    nixosModules.portals = { pkgs, ... }: {
      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal-wlr
        ];
        config.common.default = [
          "wlr"
          "gtk"
        ];
        xdgOpenUsePortal = true;
      };
      # services.xdg-desktop-portal.enable = true;
      # services.xdg-desktop-portal.backends = [ pkgs.xdg-desktop-portal-gtk ];

      environment.sessionVariables = {
        GTK_USE_PORTAL = "1";
      };
    };
  };
}

