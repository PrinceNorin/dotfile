return {
  'hrsh7th/cmp-nvim-lsp',
  dependencies = { 'hrsh7th/nvim-cmp' },
  config = function()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    vim.lsp.config('*', {
      capabilities = capabilities,
    })

    vim.lsp.enable('gopls')
    vim.lsp.enable('jdtls')
    vim.lsp.enable('kotlin-lsp')
  end,
}
