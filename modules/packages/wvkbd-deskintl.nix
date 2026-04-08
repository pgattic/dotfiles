{
  perSystem = { pkgs, ... }: let
    wvkbd-deskintl = pkgs.wvkbd.overrideAttrs (old: {
      pname = "wvkbd-deskintl";
      postPatch = (old.postPatch or "") + ''
        substituteInPlace config.mk \
          --replace 'LAYOUT = mobintl' 'LAYOUT = deskintl'
      '';
    });
  in {
    overlayAttrs = { inherit wvkbd-deskintl; };
    packages = { inherit wvkbd-deskintl; };
  };
}

