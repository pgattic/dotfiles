
local h_ui = require("harpoon.ui")
local h_mark = require("harpoon.mark")


vim.keymap.set("n", "<leader>ht", h_ui.toggle_quick_menu)
vim.keymap.set("n", "<leader>hi", h_mark.add_file)

vim.keymap.set("n", "<A-a>", ":lua require('harpoon.ui').nav_file(1)<CR>", {silent=true})
vim.keymap.set("n", "<A-s>", ":lua require('harpoon.ui').nav_file(2)<CR>", {silent=true})
vim.keymap.set("n", "<A-d>", ":lua require('harpoon.ui').nav_file(3)<CR>", {silent=true})
vim.keymap.set("n", "<A-f>", ":lua require('harpoon.ui').nav_file(4)<CR>", {silent=true})


vim.keymap.set("n", "<A-w>", h_ui.nav_prev)
vim.keymap.set("n", "<A-e>", h_ui.nav_next)

-- vim.api.nvim_create_autocmd("FileType", {
--  pattern = "harpoon-menu"
--  callback = function(event)
--    vim.keymap.set("n", "<Leader>f", ":echo 'hi'<CR>", { buffer = event.buf })
--    vim.keymap.set("n", "J", ":m '>+1<CR>gv=gv", { buffer = event.buf })
--    vim.keymap.set("n", "K", ":m '<-2<CR>gv=gv", { buffer = event.buf })
--  end,
--})

