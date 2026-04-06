let
  hmModule = { config, pkgs, ... }: {
    programs.nushell = {
      enable = true;
      settings = {
        buffer_editor = "nvim";
        show_banner = false;
        filesize = {
          unit = "binary";
          # unit = "B";
          # show_unit = false;
        };
        history = {
          file_format = "sqlite";
          isolation = true; # Don't mix history from concurrent sessions
        };
        completions = {
          case_sensitive = true;
        };
        # table = {
        #   index_mode = "auto";
        # };
      };
      extraConfig = ''
        # Startup commands
        open --raw "${../../assets}/torterra.txt" | print
        $"Uptime: (ansi green_bold)((sys host).uptime)(ansi reset)" | print
        $"Memory used: (ansi green_bold)(sys mem | get used)(ansi reset)/(ansi green_bold)(sys mem | get total)(ansi reset)" | print
        "\"You are nothing but an unreliable wizard\" - Bruce Webster" | print
      '';
    };
  };
in {
  flake = {
    nixosModules.nushell = { config, pkgs, ... }: {
      home-manager.users.${config.my.user.name} = hmModule;
      users.users.${config.my.user.name}.shell = pkgs.nushell;
      environment.sessionVariables = {
        SHELL = "nu";
      };
    };
    homeModules.nushell = hmModule;
  };
}

