local lspconfig = require "lspconfig"
local lsp_defaults = lspconfig.util.default_config
local _border = "rounded"

require("mason").setup {
  ui = {
    border = _border
  }
}
local ensure_installed = { "lua_ls", "gopls" }
if not vim.fn.has("android") then
  table.insert(ensure_installed, "rust_analyzer")
end
require("mason-lspconfig").setup {
  ensure_installed = ensure_installed
}

lsp_defaults.capabilities = vim.tbl_deep_extend(
  "force",
  lsp_defaults.capabilities,
  require("cmp_nvim_lsp").default_capabilities()
)

require("mason-lspconfig").setup_handlers {
  function(server_name)
    lspconfig[server_name].setup {}
  end,
}

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = _border
  }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = _border
  }
)

vim.diagnostic.config {
  float = { border = _border }
}

vim.diagnostic.config({
  virtual_text = {
    source = "if_many",
  },
  float = {
    source = "if_many",
  },
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    float = { border = "rounded" },
  }
)

-- Go format using goimports on save
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({ async = false })
  end
})
