
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim' -- package manager
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }

end
vim.opt.rtp:prepend(lazypath)


require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration
  
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  
  -- bracket completer
  "m4xshen/autoclose.nvim",
  
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  
  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',
  
    -- Useful status updates for LSP
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { 'j-hui/fidget.nvim', opts = {} },
  
    -- Additional lua configuration, makes nvim stuff amazing!
    'folke/neodev.nvim',
    },
  },
  
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
  
    -- Adds LSP completion capabilities
    'hrsh7th/cmp-nvim-lsp',
  
    -- Adds a number of user-friendly snippets
    'rafamadriz/friendly-snippets',
    },
    opts = {
    performance = {
      max_view_entries = 8,
    },
    completion = {
      keyword_length = 1,
    },
    experimental = {
      ghost_text = true,
    },
  
    mapping = {
      ['<Tab>'] = function(fallback) -- make tab select and confirm the first option
      local cmp = require "cmp"
      if cmp.visible() then
        cmp.confirm()
      else
        fallback()
      end
      end,
      ['<CR>'] = function(fallback) -- Enter now does its usual thing
      fallback()
      end
    }
    }
  },
  
  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
    -- See `:help gitsigns.txt`
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
      vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
      vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
    end,
    },
  },
  
  {
    'Mofiqul/vscode.nvim',
    priority = 1000,
    config = function()
    vim.cmd.colorscheme 'vscode'
    end,
  },
  
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
    options = {
      icons_enabled = false,
      theme = 'vscode',
      component_separators = '|',
      section_separators = '',
    },
    },
  },
  
  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
    char = '┊',
    show_trailing_blankline_indent = false,
    },
  },
  
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },
  
  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
  
  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
    return vim.fn.executable 'make' == 1
    end,
  },
  
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
}, {})
  
  