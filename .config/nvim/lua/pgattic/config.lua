
-- Nvim Config --

-- disable netrw (in favor of nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.fillchars = {eob = " "}

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.nu = true -- line numbers

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.termguicolors = true

vim.opt.smartindent = true

vim.opt.scrolloff = 4
--vim.opt.sigcolumn = "yes"

vim.opt.colorcolumn = "100"

vim.opt.mouse = "a"


vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.cursorline = true

vim.opt.laststatus = 3 -- makes LuaLine fullwidth

vim.opt.title = true
--vim.opt.titlestring = "yeet"

-- vim.opt.cmdheight = 0

vim.cmd(":command W w") -- Resolves a carpal race condition

vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr-o:hor20"

vim.o.guifont = "JetBrainsMono Nerd font:h10"
vim.g.neovide_transparency = 0.8


