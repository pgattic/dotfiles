{ config, pkgs, inputs, ... }: {
  imports = [ ../default.nix ];

  my.desktop = {
    enable = true;
    mod_key = "Alt";
    touch_options = true;
  };
}

