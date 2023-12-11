-- Telescope Config --

local builtin = require("telescope.builtin")

vim.keymap.set('n', "<leader>pf", builtin.find_files, {})
vim.keymap.set('n', '<leader>pg', builtin.live_grep, {})
vim.keymap.set("n", "<leader>gf", builtin.git_files, {})
-- vim.keymap.set("n", "<leader>gg", builtin.git_grep, {})

