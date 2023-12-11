
-- Nvim Config --

-- disable netrw (in favor of nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


vim.g.mapleader = " "
vim.g.maplocalleader = ' '

vim.opt.nu = true -- line numbers

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.termguicolors = true

vim.opt.smartindent = true

vim.opt.scrolloff = 8
--vim.opt.sigcolumn = "yes"

vim.opt.colorcolumn = "80"

vim.opt.mouse = "a"


vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.cursorline = true

vim.opt.laststatus = 3 -- makes LuaLine fullwidth

