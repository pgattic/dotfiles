# Make Luanti prefer Wayland over X11.
# Uses the paths from regular version of Luanti to avoid compiling it from source
{
  perSystem = { pkgs, ... }: let
    base = pkgs.luanti-client;
    luanti-client = pkgs.symlinkJoin {
      name = "${base.pname or "luanti-client"}-${base.version or "unknown"}";
      paths = [ base ];
      nativeBuildInputs = [ pkgs.makeWrapper ];

      postBuild = ''
        wrapProgram $out/bin/luanti \
        --set SDL_VIDEODRIVER "wayland,x11"
      '';

      meta = base.meta // {
        version = base.version or base.meta.version;
      };
    };
  in {
    overlayAttrs = { inherit luanti-client; };
    packages = { inherit luanti-client; };
  };
}

