
-- System Package Requirements:
-- ripgrep (for telescope's live_grep command)


require("pgattic")


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  { "Mofiqul/vscode.nvim", name = "vscode", priority = 1000 },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
  {"nvim-treesitter/nvim-treesitter-context"},
  {"nvim-treesitter/nvim-treesitter-refactor"},
  {"windwp/nvim-ts-autotag"}, -- HTML closing tags

  -- LSP Packages
  {"mason-org/mason.nvim"},
  {"mason-org/mason-lspconfig.nvim"},
  {"neovim/nvim-lspconfig"},

  -- Autocomplete
  {
    "hrsh7th/nvim-cmp",
    opts = { experimental = {ghost_text = true,},},
  },
  {"hrsh7th/cmp-nvim-lsp"},
  {"L3MON4D3/LuaSnip"},

  {"mbbill/undotree"},

  {"lewis6991/gitsigns.nvim"},

  {"nvim-lualine/lualine.nvim"},

  { "m4xshen/autoclose.nvim" },

  {
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
  },

  -- Harpoon
  -- {"ThePrimeagen/harpoon"},
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  },


  {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = true,
  },

  { 'echasnovski/mini.nvim', version = false },

  {"Djancyp/better-comments.nvim"},
  {'nvim-tree/nvim-web-devicons'},
  -- {"Exafunction/codeium.vim"},
  {'petertriho/nvim-scrollbar'},

  {
    'MeanderingProgrammer/render-markdown.nvim',
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  }
}

local opts = {}

require("lazy").setup(plugins, opts)

