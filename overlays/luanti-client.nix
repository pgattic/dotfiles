# Make Luanti prefer Wayland over X11.
# Uses the paths from regular version of Luanti to avoid compiling it from source
final: prev: {
  luanti-client =
    let
      base = prev.luanti-client;
    in
      final.symlinkJoin {
        name = "${base.pname or "luanti-client"}-${base.version or "unknown"}";
        paths = [ base ];
        nativeBuildInputs = [ final.makeWrapper ];

        postBuild = ''
          wrapProgram $out/bin/luanti \
          --set SDL_VIDEODRIVER "wayland,x11"
        '';

        meta = base.meta // {
          version = base.version or base.meta.version;
        };
      };
}

