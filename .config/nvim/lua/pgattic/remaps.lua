
-- Remaps --

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set({"n", "v"}, "x", "\"_x") -- don't yank on "x"!

--vim.keymap.set("n", "<leader>pd", vim.cmd.Ex)

-- custom terminal setup (by me!)
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = "*",
  callback = function()
    vim.opt_local.nu = false
  end
})

vim.keymap.set("n", "<leader>t", ":sp<CR><C-w><C-r>:resize 12<CR>:terminal<CR>$a")

vim.keymap.set("n", "J", "mzJ`z") -- Line-appending: Keep cursor location

vim.keymap.set({"n", "v"}, "<leader>y", "\"+y") -- System Copy
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "n", "nzzzv") -- Keep searhch terms in the middle of the screen
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<CR>", ":noh<CR><CR>", {silent = true}) -- Return also removes search highlights

vim.keymap.set("x", "p", "\"_dP")  -- do not modify registers on paste

vim.keymap.set("v", ">", ">gv") -- Indentation: Stay in Visual Mode
vim.keymap.set("v", "<", "<gv")


