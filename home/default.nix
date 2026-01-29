{ config, pkgs, inputs, ... }:
let
  username = "pgattic";
  home_dir = "/home/${username}";
in {
  imports = [ # Importing these doesn't automatically enable their options
    ./desktop.nix
  ];

  home.username = username;
  home.homeDirectory = home_dir;

  home.packages = with pkgs; [
    (lib.hiPrio uutils-coreutils-noprefix) # uutils preferred over GNU coreutils
    openssh_hpn # SSH but faster
    usbutils
    ripgrep
    bat
    gdu
    less
    file
    tree
    lazygit
    ouch # Archive manager
    jq
    tinyxxd

    nil # Nix language server
    nix-output-monitor # provides `nom` as a cooler replacement for `nix` commands
  ];

  stylix.targets.neovim.enable = false;

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      settings = {
        user.name = username;
        user.email = "pgattic@gmail.com";
        color.ui = "auto";
        init.defaultBranch = "master";
      };
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
    nushell = {
      enable = true;
      environmentVariables = {
        EDITOR = "nvim";
        NH_OS_FLAKE = "${home_dir}/dotfiles";
      };
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
      extraEnv = ''
        # Won't hurt if these paths don't exist on the current system
        $env.path ++= [
          "${home_dir}/bin", # User binaries
          # "${home_dir}/.cargo/bin", # Rust binaries
          # "${home_dir}/.ghcup/bin" # Haskell binaries
          # "${home_dir}/.opam/default/bin" # OPAM binaries
        ]
      '';
      extraConfig = ''
        # Startup commands
        open --raw "${home_dir}/dotfiles/config/nushell/torterra.txt" | print
        $"Uptime: (ansi green_bold)((sys host).uptime)(ansi reset)" | print
        $"Memory used: (ansi green_bold)(sys mem | get used)(ansi reset)/(ansi green_bold)(sys mem | get total)(ansi reset)" | print
        "\"You are nothing but an unreliable wizard\" - Bruce Webster" | print
      '';
    };
    btop = {
      enable = true;
      settings = {
        theme_background = false;
        vim_keys = true;
        proc_gradient = false;
        proc_filter_kernel = true;
      };
    };
    nh = {
      enable = true;
      flake = "${home_dir}/dotfiles";
    };
    zellij = {
      enable = true;
      settings = {
        show_startup_tips = false;
      };
    };
    fastfetch = {
      enable = true;
      settings = {
        "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json";
        "modules" = [
          "title"
          "separator"
          "os" "host" "kernel"
          "uptime"
          "packages"
          "shell"
          "display"
          "de" "wm"
          "terminal" "terminalfont"
          "cpu" "gpu" "memory" "swap" "disk"
          "localip"
          "battery"
          "poweradapter"
          "break"
          "colors"
        ];
      };
    };
  };

  home.sessionVariables = { # For terminal shells, not for the desktop
    EDITOR = "nvim";
    NH_OS_FLAKE = "${home_dir}/dotfiles";
  };

  home.stateVersion = "25.11"; # Don't
}

