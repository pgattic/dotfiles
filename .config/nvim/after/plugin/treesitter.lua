
-- TreeSitter Config --

local config = require("nvim-treesitter.configs")

config.setup({
  auto_install = true,
  ensure_installed = { "lua", "c" },
  highlight = {enable=true},
  indent = {enable=true},
})


