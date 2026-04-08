# Mineclonia game for Luanti
{
  perSystem = { pkgs, ... }: let
    src = pkgs.fetchzip {
      url = "https://codeberg.org/mineclonia/mineclonia/archive/0.120.1.tar.gz";
      hash = "sha256-PZr31TsxkHYg0Z2w1q8Qqfvp9iMuwcmxyX2jrPd9ffo=";
      stripRoot = true;
    };
    mineclonia-game = pkgs.runCommand "mineclonia-subgames" {} ''
      mkdir -p "$out"
      ln -s ${src} "$out/mineclonia"
    '';
  in {
    overlayAttrs = { inherit mineclonia-game; };
    packages = { inherit mineclonia-game; };
  };
}

