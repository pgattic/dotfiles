{ config, lib, inputs, ... }:
let
  cfg = config.my.desktop.portals;
in {
  options = {
    my.desktop.portals = {
      enable = lib.mkEnableOption "XDG Desktop portals";
    };
  };

  config = lib.mkIf cfg.enable {
    flake.modules.nixos.portals = { pkgs, ... }: {
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
    flake.modules.homeManager.portals = { ... }: {
    };
  };
}

