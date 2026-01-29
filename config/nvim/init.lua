
-- Neovim Config --

-- OPTIONS --

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.mouse = "a" -- Enable mouse controls for all modes
vim.opt.swapfile = false
-- Visuals
vim.opt.nu = true -- line numbers
vim.opt.termguicolors = true -- Allow 24-bit RGB colors
vim.opt.colorcolumn = "100"
vim.opt.cursorline = true
vim.opt.fillchars = { eob = " " } -- Don't fill the extra space with "~"
vim.opt.winborder = 'rounded'
vim.opt.scrolloff = 4
vim.opt.signcolumn = "yes" -- Always show gutter even if empty
vim.opt.title = true
-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
-- Disable unused features
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_matchit = 1

-- GLOBAL KEYMAPS --

vim.keymap.set("n", "Q", "<nop>") -- Disable (legacy) Ex mode

vim.keymap.set("v", ">", ">gv") -- Indentation: Stay in Visual Mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- Code block movement
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z") -- Line-appending: Keep cursor location
vim.keymap.set({"n", "v"}, "x", "\"_x") -- don't yank on "x"
vim.keymap.set("x", "p", "\"_dP")  -- do not modify registers on paste

vim.keymap.set("n", "n", "nzzzv") -- Keep search terms in the middle of the screen
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<CR>", ":noh<CR><CR>", {silent = true}) -- Return also removes search highlights

-- OTHER --

-- Custom filetype configs
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("CustomFileConfigs", { clear = true }),
  callback = function(ev)
    if ev.match == "openscad" then
      vim.bo.commentstring = "// %s"
    end
  end,
})

-- PLUGINS --

local plugins = {
  { src = "https://github.com/nvim-tree/nvim-web-devicons" }, -- used by telescope, mini.files, others
  { src = "https://github.com/nvim-lua/plenary.nvim" }, -- Dependency of telescope and others

  { src = "https://github.com/Mofiqul/vscode.nvim", name = "vscode" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/mbbill/undotree" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" }, -- Default lsp config options
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/stevearc/dressing.nvim" },
  { src = "https://github.com/saghen/blink.cmp" },
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/nvim-mini/mini.files" },
  { src = "https://github.com/kdheepak/lazygit.nvim" },
  { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
  { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
  { src = "https://github.com/petertriho/nvim-scrollbar" },
}

-- TODO: Remove the lazy.nvim-related stuff once Neovim 0.12 is released
if pcall(require, "vim.pack") then
  vim.pack.add(plugins, { confirm = false })
else -- vim.pack is not available, use lazygit
  local lazy_list = {}

  for _, p in ipairs(plugins) do
    local pkg = {}
    if p.src     then pkg[1] = p.src end
    if p.name    then pkg.name = p.name end
    if p.version then pkg.branch = p.version end
    table.insert(lazy_list, pkg)
  end

  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
  end
  vim.opt.rtp:prepend(lazypath)
  require("lazy").setup(lazy_list, {})
end

-- Color Theme
require('vscode').setup({
    -- transparent = true, -- Transparent background
})
vim.cmd.colorscheme("vscode")

-- Fancy-looking bar on the bottom of the screen
require("lualine").setup()

-- Undo tree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
vim.g.undotree_WindowLayout = 3
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Git integration
require("gitsigns").setup{
  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "┃" },
    untracked = { text = "┇" },
  },
  current_line_blame = true,
  current_line_blame_opts = {
    delay = 0,
    use_focus = false,
  },
  current_line_blame_formatter = "  <author>, <author_time:%R> - <summary>",
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
  end
}

-- Language Servers
vim.lsp.inlay_hint.enable()
local lsp_servers = {
  rust_analyzer = {},
  clangd = {},
  openscad_lsp = {},
  nil_ls = {}, -- Nix language server
  hls = {}, -- Haskell Language Server
}
for server, config in pairs(lsp_servers) do
  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {}) -- TODO: remove in favor of default: grn
vim.keymap.set({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, {}) -- TODO: remove in favor of default: gra
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {}) -- TODO: remove in favor of defaults: Ctrl+] and Ctrl+T
vim.diagnostic.config({ -- Show diagnostic messages
  virtual_lines = true;
  -- virtual_text = true; -- Uncomment this and comment above line when I get annoyed with the virtual lines
})

-- Fuzzy Finder
local telescope = require("telescope.builtin")
vim.keymap.set('n', "<leader>pf", telescope.find_files, {})
vim.keymap.set('n', '<leader>pg', telescope.live_grep, {})
vim.keymap.set("n", "<leader>gf", telescope.git_files, {})

-- Completion engine
require("blink.cmp").setup({
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 0,
    },
  },
  keymap = {
    ['<Tab>'] = { 'select_and_accept', 'fallback' },
  },
  fuzzy = { implementation = "lua" },
})

require("todo-comments").setup()

-- File browser
local mini_files = require('mini.files')
mini_files.setup({ windows = { preview = true } })
vim.keymap.set('n', "<leader>pd", MiniFiles.open, {})

require("ibl").setup({
  indent = { char = "▏" },
  scope = { enabled = true, char = "▎"},
  whitespace = { remove_blankline_trail = true },
})

require("harpoon_config") -- A mess I won't write here

require("scrollbar").setup({ handle = { color = "#555555" } })


-- Extra/old stuff

-- vim.opt.mousescroll = "ver:1,hor:6" -- For some reason, Neovim scrolls way fast on Ghostty
-- vim.opt.laststatus = 3 -- makes LuaLine fullwidth
-- vim.opt.cmdheight = 0
-- vim.cmd(":command W w") -- Resolves a carpal race condition
-- vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr-o:hor20"
-- vim.opt.eol = false -- Don't add newlines

-- vim.keymap.set("n", "<leader>0x", ":%!xxd -g 1<CR>:set ft=xxd<CR>") -- Open buffer in xxd
-- vim.keymap.set("n", "<leader>0q", ":%!xxd -r<CR>:filetype detect<CR>") -- revert xxd buffer into text
-- vim.keymap.set("n", "<leader>0r", "mz:%!xxd -r | xxd -g 1<CR>`z") -- "refresh" hex data (preserve cursor location)

