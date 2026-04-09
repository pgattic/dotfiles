{
  perSystem = { pkgs, self', ... }: {
    packages.desktop = pkgs.symlinkJoin {
      # This "desktop" meta-package provides graphical programs commonly used, but not required for desktop use
      name = "desktop";
      paths = [
        pkgs.imv
        pkgs.mpv-unwrapped
        pkgs.kdePackages.ark
          # pkgs.unrar # Nonfree package # TODO: get a system to include this
        pkgs.kdePackages.dolphin
        # TODO: Sioyek? office utilities? Obsidian?
      ];
    };
  };
}

