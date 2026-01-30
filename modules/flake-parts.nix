{ lib, ... }: {
  options.flake.modules = lib.mkOption {
    type = lib.types.attrsOf (lib.types.attrsOf lib.types.raw);
    default = {};
    description = "Reusable NixOS and Home Manager module fragments for this flake.";
  };

  config.systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];
}
