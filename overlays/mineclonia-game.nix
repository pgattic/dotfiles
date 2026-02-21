# Mineclonia game for Luanti
final: prev: {
  mineclonia-game = let
    src = prev.fetchzip {
      url = "https://codeberg.org/mineclonia/mineclonia/archive/0.120.0.tar.gz";
      hash = "sha256-j/fQK5/WWAp7SDoaTIrOBK5zq+Zhuwp33cY8/nYJbII=";
      stripRoot = true;
    };
  in prev.runCommand "mineclonia-subgames" {} ''
    mkdir -p "$out"
    ln -s ${src} "$out/mineclonia"
  '';
}

