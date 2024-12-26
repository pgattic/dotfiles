

-- LSP (Mason) Setup --

require("flutter-tools").setup({}) -- use defaults
require('better-comment').Setup()

require("mason").setup()

local mason_lspconfig = require("mason-lspconfig")

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

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
    }
  end,
}

-- Temporary workaround for rust-analyzer changes
for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
    local default_diagnostic_handler = vim.lsp.handlers[method]
    vim.lsp.handlers[method] = function(err, result, context, config)
        if err ~= nil and err.code == -32802 then
            return
        end
        return default_diagnostic_handler(err, result, context, config)
    end
end

