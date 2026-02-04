{
  flake = {
    nixosModules.zeditor = { ... }: {};
    homeModules.zeditor = { ... }: {
      programs.zed-editor = {
        enable = true;
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
  };
}

