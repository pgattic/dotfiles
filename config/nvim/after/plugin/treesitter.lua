
-- TreeSitter Config --

require('nvim-ts-autotag').setup()

local config = require("nvim-treesitter.configs")

config.setup({
  auto_install = true,
  highlight = {enable=true},
  indent = {enable=true},
  refactor = {
    highlight_definitions = {
      enable = true,
      -- Set to false if you have an `updatetime` of ~100.
      clear_on_cursor_move = true,
    },
    -- smart_rename = {
    --   enable = true,
    --   -- Assign keymaps to false to disable them, e.g. `smart_rename = false`.
    --   keymaps = {
    --     smart_rename = "<leader>r",
    --   },
    -- },
  },
})

vim.keymap.set("n", "<leader>ast", ":InspectTree<CR>")

require('treesitter-context').setup{
  mode = 'topline',
}

