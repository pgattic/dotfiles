{ inputs, ... }: {
  perSystem = { pkgs, ... }: let
    wlib = inputs.nix-wrapper-modules.lib;
  in {
    packages.neovim = wlib.evalPackage ({ config, lib, ... }: {
      inherit pkgs;
      imports = [ wlib.wrapperModules.neovim ];

      settings = {
        config_directory = ./.;
        aliases = [ "vi" "vim" "vimdiff" ];
      };

      specs = with pkgs.vimPlugins; {
        devicons   = nvim-web-devicons;
        vscode     = vscode-nvim;
        lualine    = lualine-nvim;
        undotree   = undotree;
        gitsigns   = gitsigns-nvim;
        lspconfig  = nvim-lspconfig;
        telescope  = telescope-nvim;
        dressing   = dressing-nvim;
        blink      = blink-cmp;
        todo       = todo-comments-nvim;
        mini-files = mini-files;
        lazygit    = lazygit-nvim;
        ibl        = indent-blankline-nvim;
        harpoon    = harpoon2;
        lean       = lean-nvim;
      };
      hosts.python3.nvim-host.enable = false;
      hosts.ruby.nvim-host.enable = false;
      hosts.node.nvim-host.enable = false;
    });
  };
}

