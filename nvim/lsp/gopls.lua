return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  on_attach = function(client, bufnr)
    local map = vim.keymap.set
    local opts = { buffer = bufnr }

    map('n', 'gd', vim.lsp.buf.definition, opts)
    map('n', 'K', vim.lsp.buf.hover, opts)
    map('n', '<leader>ca', vim.lsp.buf.code_action, opts)

    local function organize_imports(client)
      local win_id = vim.api.nvim_get_current_win()
      local encoding = client.offset_encoding or 'utf-18'
      local params = vim.lsp.util.make_range_params(win_id, encoding)

      params.context = {
        diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
        only = { 'source.organizeImports' },
      }

      vim.lsp.buf_request(0, "textDocument/codeAction", params, function(err, results, ctx)
        if err then return end

        for _, result in pairs(results or {}) do
          if result.edit then
            vim.lsp.util.apply_workspace_edit(result.edit, encoding)
          end
        end
      end)
    end

    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = { '*.go' },
      callback = function(args)
        local clients = vim.lsp.get_clients({ bufnr = args.buf, name = 'gopls' })
        if #clients == 0 then return end

        organize_imports(clients[1])

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
