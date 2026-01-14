{ config, pkgs, inputs, ... }: {
  imports = [ ../default.nix ];

  my.desktop = {
    enable = true;
    mod_key = "Alt";
    cpu_cores = 4;
    touch_options = true;
  };
}

