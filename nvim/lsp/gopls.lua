return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  on_attach = function(client, bufnr)
    local map = vim.keymap.set
    local opts = { buffer = bufnr }

    map('n', 'gd', vim.lsp.buf.definition, opts)
    map('n', 'K', vim.lsp.buf.hover, opts)
    map('n', '<leader>ca', vim.lsp.buf.code_action, opts)

    local function organize_imports()
      local params = vim.lsp.util.make_range_params()
      params.context = {
        diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
        only = { 'source.organizeImports' },
      }

      vim.lsp.buf_request(0, "textDocument/codeAction", params, function(err, results, ctx)
        if err then return end

        for _, result in pairs(results or {}) do
          if result.edit then
            local client = vim.lsp.get_client_by_id(ctx.client_id)
            if client then
              vim.lsp.util.apply_workspace_edit(result.edit, client.offset_encoding or 'utf-16')
            else
              vim.lsp.util.apply_workspace_edit(result.edit, 'utf-16')
            end
          end
        end
      end)
    end

    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = { '*.go' },
      callback = function(args)
        local clients = vim.lsp.get_clients({ bufnr = args.buf, name = 'gopls' })
        if #clients == 0 then return end

        organize_imports()

        vim.lsp.buf.format({
          bufnr = args.buf,
          filter = function(client)
            return client.name == 'gopls'
          end,
          timeout_ms = 2000,
        })
      end,
    })
  end,
}
