let
  desktop = {
    opacity = 0.85;
    corner-radius = 10.0;
  };
in {
  flake = {
    inherit desktop;
  };
}

