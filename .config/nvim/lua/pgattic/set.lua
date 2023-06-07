
vim.opt.hlsearch = false

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.mouse = 'a' -- mouse mode

vim.opt.clipboard = 'unnamedplus' -- OS clipboard sync

vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 50
-- vim.opt.timeout = true
-- vim.opt.timeoutlen = 300

-- Set completeopt to have a better completion experience
-- vim.opt.completeopt = 'menuone,noselect'

vim.opt.termguicolors = true


vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 0
vim.opt.expandtab = true

vim.opt.linebreak = true

vim.opt.smartindent = true

vim.opt.scrolloff = 8

vim.opt.colorcolumn = "80"


-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
