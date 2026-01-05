# Mineclonia game for Luanti
final: prev: {
  mineclonia-game = let
    src = prev.fetchzip {
      url = "https://codeberg.org/mineclonia/mineclonia/archive/0.118.1.tar.gz";
      hash = "sha256-Px50glmLNz1/9ViZFf2NTGpNwgrMRflHAaZ1mSXEzGk=";
      stripRoot = true;
    };
  in prev.runCommand "mineclonia-subgames" {} ''
    mkdir -p "$out"
    ln -s ${src} "$out/mineclonia"
  '';
}

