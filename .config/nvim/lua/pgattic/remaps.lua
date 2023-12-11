
-- Remaps --

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "x", "\"_x") -- don't yank on "x"!

--vim.keymap.set("n", "<leader>pd", vim.cmd.Ex)

-- custom terminal setup (by me!)
vim.keymap.set("n", "<leader>t", ":terminal<CR>$a")
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = "*",
  callback = function()
    vim.opt_local.nu = false
  end
})

