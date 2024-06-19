
local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>hi", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>ht", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set({"n", "t", "i"}, "<A-1>", function() harpoon:list():select(1) end)
vim.keymap.set({"n", "t", "i"}, "<A-2>", function() harpoon:list():select(2) end)
vim.keymap.set({"n", "t", "i"}, "<A-3>", function() harpoon:list():select(3) end)
vim.keymap.set({"n", "t", "i"}, "<A-4>", function() harpoon:list():select(4) end)
vim.keymap.set({"n", "t", "i"}, "<A-5>", function() harpoon:list():select(5) end)
vim.keymap.set({"n", "t", "i"}, "<A-6>", function() harpoon:list():select(6) end)
vim.keymap.set({"n", "t", "i"}, "<A-7>", function() harpoon:list():select(7) end)
vim.keymap.set({"n", "t", "i"}, "<A-8>", function() harpoon:list():select(8) end)
vim.keymap.set({"n", "t", "i"}, "<A-9>", function() harpoon:list():select(9) end)
vim.keymap.set({"n", "t", "i"}, "<A-0>", function() harpoon:list():select(10) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<A-h>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<A-l>", function() harpoon:list():next() end)

function Harpoon_files()
  local contents = {}
  local marks_length = harpoon:list():length()
  local current_file_path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
  for index = 1, marks_length do
    local harpoon_file_path = harpoon:list():get(index).value
    local file_name = harpoon_file_path == "" and "(empty)" or vim.fn.fnamemodify(harpoon_file_path, ':t')

    if current_file_path == harpoon_file_path then
      contents[index] = string.format("%%#HarpoonNumberActive# %s %%#HarpoonActive#%s", index, file_name)
    else
      contents[index] = string.format("%%#HarpoonNumberInactive# %s %%#HarpoonInactive#%s", index, file_name)
    end
  end

  return table.concat(contents, " │")
end

local function get_lualine_config()
  if harpoon:list():length() > 0 then
    return {
      tabline = {
        lualine_c = { { Harpoon_files } },
      },
    }
  else
    return {}
  end
end

-- vim.opt.showtabline = 2
-- vim.api.nvim_create_autocmd({ "BufEnter", "BufAdd", "User" }, {
--     callback = function(ev)
--         if harpoon:list():length() > 0 then
--             vim.o.tabline = Harpoon_files()
--         end
--     end
-- })

require('lualine').setup(get_lualine_config())

-- -- Trigger the autocommand manually if you add/remove files to Harpoon programmatically
-- harpoon.events.on("add", function()
--   require('lualine').setup(get_lualine_config())
-- end)
--
-- harpoon.events.on("rm", function()
--   require('lualine').setup(get_lualine_config())
-- end)

vim.cmd('highlight! HarpoonInactive guibg=NONE guifg=#63698c')
vim.cmd('highlight! HarpoonActive guibg=NONE guifg=white')
vim.cmd('highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7')
vim.cmd('highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7')
vim.cmd('highlight! TabLineFill guibg=NONE guifg=white')
