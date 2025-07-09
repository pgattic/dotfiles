
local mini_files = require('mini.files')

mini_files.setup({
  windows = {
    preview = true,
  },
})


vim.keymap.set('n', "<leader>pd", MiniFiles.open, {})


