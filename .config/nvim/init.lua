
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
  {"windwp/nvim-ts-autotag"},

  -- LSP Packages
  {"williamboman/mason.nvim"},
  {"williamboman/mason-lspconfig.nvim"},
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

  {"nvim-tree/nvim-tree.lua"},
  {"nvim-tree/nvim-web-devicons"},

  {"nvim-lualine/lualine.nvim"},

  { "m4xshen/autoclose.nvim" },

  {
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
  },

  -- Harpoon
  {"ThePrimeagen/harpoon"},


  {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = true,
  }
}

local opts = {}

require("lazy").setup(plugins, opts)

