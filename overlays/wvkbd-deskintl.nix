final: prev: {
  wvkbd-deskintl = prev.wvkbd.overrideAttrs (old: {
    pname = "wvkbd-deskintl";
    postPatch = (old.postPatch or "") + ''
      substituteInPlace config.mk \
        --replace 'LAYOUT = mobintl' 'LAYOUT = deskintl'
    '';
  });
}

