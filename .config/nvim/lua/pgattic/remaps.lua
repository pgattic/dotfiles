
-- Remaps --

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set({"n", "v"}, "x", "\"_x") -- don't yank on "x"!

-- custom terminal setup (by me :))
vim.keymap.set("n", "<leader>t", ":sp<CR><C-w><C-r>:resize 12<CR>:terminal<CR>$a")
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = "*",
  callback = function()
    vim.opt_local.nu = false
  end
})

vim.keymap.set("n", "J", "mzJ`z") -- Line-appending: Keep cursor location

vim.keymap.set({"n", "v"}, "<leader>y", "\"+y") -- System Copy
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "n", "nzzzv") -- Keep searhch terms in the middle of the screen
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<CR>", ":noh<CR><CR>", {silent = true}) -- Return also removes search highlights

vim.keymap.set("x", "p", "\"_dP")  -- do not modify registers on paste

vim.keymap.set("v", ">", ">gv") -- Indentation: Stay in Visual Mode
vim.keymap.set("v", "<", "<gv")

vim.keymap.set("n", "<leader>0x", ":%!xxd -g 1<CR>:set ft=xxd<CR>") -- Open buffer in xxd
vim.keymap.set("n", "<leader>0q", ":%!xxd -r<CR>:filetype detect<CR>") -- revert xxd buffer into text
vim.keymap.set("n", "<leader>0r", "mz:%!xxd -r | xxd -g 1<CR>`z") -- "refresh" hex data (preserve cursor location)

vim.keymap.set("n", "<Tab>", "<Esc>f|lR")

-- Notes about shortcuts--
-- <M-[> is alt-[
-- <C-[> is ctrl-[
-- <C-[> is ctrl-[
-- <S-[> is shift-[
--
-- <CR> is Enter
-- <Esc> is ESC
-- <Tab> is Tab
-- <BS> is Backspace
-- <Del> is Delete
-- <Space> is Space
-- <Up> is Up
-- <Down> is Down
-- <Left> is Left
-- <Right> is Right

