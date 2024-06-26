
require("gitsigns").setup{
  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "┃" },
    untracked = { text = "┇" },
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
  end
}

