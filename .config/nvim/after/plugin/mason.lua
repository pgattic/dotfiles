

-- LSP (Mason) Setup --

require("flutter-tools").setup({}) -- use defaults
require('better-comment').Setup()

require("mason").setup()

local mason_lspconfig = require("mason-lspconfig")


local servers = { -- use :Mason to search for language server names
  clangd = {},
  csharp_ls = {},

  eslint = {},

  gopls = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

local server_deps = {
  "cc",
  "dotnet",
  "node",
  "go",
  "lua",
}

local servers_filtered = {}
local filtered_idx = 1

for i, dep in pairs(server_deps) do
  if vim.fn.executable(dep) == 1 then
    servers_filtered[filtered_idx] = servers[i]
    filtered_idx = filtered_idx + 1
  end
end

vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {})
vim.keymap.set({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, {})

vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})

-- Flutter keybinds

vim.keymap.set("n", "<leader>ff", ":FlutterRun<CR>")
vim.keymap.set("n", "<leader>fr", ":FlutterReload<CR>")
vim.keymap.set("n", "<leader>fq", ":FlutterQuit<CR>")

local on_attach = function(_, _)
  vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {})
  vim.keymap.set({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, {})

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})

  vim.lsp.inlay_hint.enable()
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers_filtered),
})

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}


