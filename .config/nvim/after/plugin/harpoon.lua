
require("harpoon").setup({
  tabline = true
})
local h_ui = require("harpoon.ui")
local h_mark = require("harpoon.mark")


vim.keymap.set("n", "<leader>ht", h_ui.toggle_quick_menu)
vim.keymap.set("n", "<leader>hi", h_mark.add_file)

vim.keymap.set({"n", "t", "i"}, "<A-1>", "<C-\\><C-n>:lua require('harpoon.ui').nav_file(1)<CR>", {silent=true})
vim.keymap.set({"n", "t", "i"}, "<A-2>", "<C-\\><C-n>:lua require('harpoon.ui').nav_file(2)<CR>", {silent=true})
vim.keymap.set({"n", "t", "i"}, "<A-3>", "<C-\\><C-n>:lua require('harpoon.ui').nav_file(3)<CR>", {silent=true})
vim.keymap.set({"n", "t", "i"}, "<A-4>", "<C-\\><C-n>:lua require('harpoon.ui').nav_file(4)<CR>", {silent=true})
vim.keymap.set({"n", "t", "i"}, "<A-5>", "<C-\\><C-n>:lua require('harpoon.ui').nav_file(5)<CR>", {silent=true})
vim.keymap.set({"n", "t", "i"}, "<A-6>", "<C-\\><C-n>:lua require('harpoon.ui').nav_file(6)<CR>", {silent=true})
vim.keymap.set({"n", "t", "i"}, "<A-7>", "<C-\\><C-n>:lua require('harpoon.ui').nav_file(7)<CR>", {silent=true})
vim.keymap.set({"n", "t", "i"}, "<A-8>", "<C-\\><C-n>:lua require('harpoon.ui').nav_file(8)<CR>", {silent=true})
vim.keymap.set({"n", "t", "i"}, "<A-9>", "<C-\\><C-n>:lua require('harpoon.ui').nav_file(9)<CR>", {silent=true})
vim.keymap.set({"n", "t", "i"}, "<A-0>", "<C-\\><C-n>:lua require('harpoon.ui').nav_file(10)<CR>", {silent=true})

vim.keymap.set("n", "<A-h>", h_ui.nav_prev)
vim.keymap.set("n", "<A-l>", h_ui.nav_next)


vim.keymap.set({"n", "t"}, "<A-z>", "<C-\\><C-n>:lua require('harpoon.term').gotoTerminal(1)<CR>a", {silent=true})
vim.keymap.set({"n", "t"}, "<A-x>", "<C-\\><C-n>:lua require('harpoon.term').gotoTerminal(2)<CR>a", {silent=true})
vim.keymap.set({"n", "t"}, "<A-c>", "<C-\\><C-n>:lua require('harpoon.term').gotoTerminal(3)<CR>a", {silent=true})
vim.keymap.set({"n", "t"}, "<A-v>", "<C-\\><C-n>:lua require('harpoon.term').gotoTerminal(4)<CR>a", {silent=true})

vim.cmd('highlight! HarpoonInactive guibg=NONE guifg=#63698c')
vim.cmd('highlight! HarpoonActive guibg=NONE guifg=white')
vim.cmd('highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7')
vim.cmd('highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7')
vim.cmd('highlight! TabLineFill guibg=NONE guifg=white')

-- vim.api.nvim_create_autocmd("FileType", {
--  pattern = "harpoon-menu"
--  callback = function(event)
--    vim.keymap.set("n", "<Leader>f", ":echo 'hi'<CR>", { buffer = event.buf })
--    vim.keymap.set("n", "J", ":m '>+1<CR>gv=gv", { buffer = event.buf })
--    vim.keymap.set("n", "K", ":m '<-2<CR>gv=gv", { buffer = event.buf })
--  end,
--})

