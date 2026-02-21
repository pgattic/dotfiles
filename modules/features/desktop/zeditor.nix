let
  hmModule = { pkgs, ... }: {
    programs.zed-editor = {
      enable = true;

      # Some libs that Codex CLI depends on
      package = pkgs.zed-editor.fhsWithPackages (pkgs: with pkgs; [
        libcap
        libz
      ]);

      userSettings = {
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
        vim_mode = true;
        window_decorations = "server";
        buffer_line_height = "standard";
        auto_update = false;
        tab_size = 2;
        inlay_hints.enabled = true;
        show_edit_predictions = false;
      };
    };
  };
in {
  flake = {
    nixosModules.zeditor = { config, ... }: {
      home-manager.users.${config.my.user.name}.imports = [ hmModule ];
    };

    homeModules.zeditor = hmModule;
  };
}

