
-- TreeSitter Config --

local config = require("nvim-treesitter.configs")

config.setup({
  auto_install = true,
  autotag = { enable = true },
  ensure_installed = { "lua", "c" },
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

require('treesitter-context').setup{
  mode = 'topline',
}

-- require('nvim-ts-autotag').setup()

