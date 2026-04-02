{
  flake = {
    nixosModules.portals = { lib, pkgs, ... }: {
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; lib.mkForce [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ];
        config.common.default = [
          "wlr"
          "gtk"
        ];
        xdgOpenUsePortal = true;
      };
      environment.sessionVariables = {
        GTK_USE_PORTAL = "1";
      };
    };
  };
}

