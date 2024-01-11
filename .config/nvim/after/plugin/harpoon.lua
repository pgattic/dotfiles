
local h_ui = require("harpoon.ui")
local h_mark = require("harpoon.mark")


vim.keymap.set("n", "<leader>ht", h_ui.toggle_quick_menu)
vim.keymap.set("n", "<leader>hi", h_mark.add_file)

vim.keymap.set({"n", "t"}, "<A-a>", "<C-\\><C-n>:lua require('harpoon.ui').nav_file(1)<CR>", {silent=true})
vim.keymap.set({"n", "t"}, "<A-s>", "<C-\\><C-n>:lua require('harpoon.ui').nav_file(2)<CR>", {silent=true})
vim.keymap.set({"n", "t"}, "<A-d>", "<C-\\><C-n>:lua require('harpoon.ui').nav_file(3)<CR>", {silent=true})
vim.keymap.set({"n", "t"}, "<A-f>", "<C-\\><C-n>:lua require('harpoon.ui').nav_file(4)<CR>", {silent=true})

vim.keymap.set("n", "<A-w>", h_ui.nav_prev)
vim.keymap.set("n", "<A-e>", h_ui.nav_next)


vim.keymap.set("n", "<A-z>", ":lua require('harpoon.term').gotoTerminal(1)<CR>a", {silent=true})
vim.keymap.set("n", "<A-x>", ":lua require('harpoon.term').gotoTerminal(2)<CR>a", {silent=true})
vim.keymap.set("n", "<A-c>", ":lua require('harpoon.term').gotoTerminal(3)<CR>a", {silent=true})
vim.keymap.set("n", "<A-v>", ":lua require('harpoon.term').gotoTerminal(4)<CR>a", {silent=true})

-- vim.api.nvim_create_autocmd("FileType", {
--  pattern = "harpoon-menu"
--  callback = function(event)
--    vim.keymap.set("n", "<Leader>f", ":echo 'hi'<CR>", { buffer = event.buf })
--    vim.keymap.set("n", "J", ":m '>+1<CR>gv=gv", { buffer = event.buf })
--    vim.keymap.set("n", "K", ":m '<-2<CR>gv=gv", { buffer = event.buf })
--  end,
--})

