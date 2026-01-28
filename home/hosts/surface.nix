{ config, pkgs, inputs, ... }: {
  imports = [ ../default.nix ];

  my.desktop = {
    enable = true;
    touch_options = true;
  };

  home.packages = with pkgs; [
    rnote
  ];
}

