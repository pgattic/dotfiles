local ntree = require("nvim-tree")



local function on_attach(bufnr)
  local api = require "nvim-tree.api"
  local tree_focus = false

  local function custom_toggle()
    tree_focus = not tree_focus
    if tree_focus then
      return api.tree.open
    else
      return "<C-w>l"
    end
  end
 -- local function opts(desc)
 --   return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
 -- end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  api.tree.toggle_gitignore_filter()

  -- custom mappings
--  vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,        opts('Up'))
--  vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))

  vim.keymap.set("n", "<leader>pd", api.tree.open)
end

ntree.setup({
  on_attach = on_attach,
  renderer = {
    add_trailing = true,
    group_empty = true,
    icons = {
      glyphs = {
        git = {
          unstaged = "~",
          untracked = "+",
        }
      },
    },
    indent_width = 2,
    indent_markers = {
      enable = true,
      inline_arrows = true,
      icons = {
        corner = "╵",
        edge = "│",
        item = "│",
        bottom = "─",
        none = " ",
      },
    },
  },
  view = {width = 30},
})

