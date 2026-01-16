{ config, pkgs, inputs, ... }: {
  imports = [ ../default.nix ];

  my.desktop = {
    enable = true;
    enable_bluetooth = true;
    cpu_cores = 4;
    touch_options = true;
  };

  home.packages = with pkgs; [
    rnote
  ];
}

