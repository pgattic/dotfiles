self: super: {
  claw-code = let
    src = super.fetchFromGitHub {
      owner = "ultraworkers"; repo = "claw-code"; rev = "be561bfdeb92fce7011938e748ee20051460d6a4";
      sha256 = "sha256-ngAd6WjyvVAKotPY0Tl9ea8DpQuSGkrclZdyiGpnyDo=";
    };
  in super.pkgs.rustPlatform.buildRustPackage {
    pname = "claw";
    version = "0.1.0";
    src = "${src}/rust";
    cargoLock.lockFile = "${src}/rust/Cargo.lock";
    doCheck = false; # Some tests are network-based, which won't work in a nix derivation
  };
}

