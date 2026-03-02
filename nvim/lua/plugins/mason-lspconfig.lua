return {
  'williamboman/mason-lspconfig.nvim',
  dependencies = {
    'williamboman/mason.nvim',
    'neovim/nvim-lspconfig',
  },
  config = function()
    require('mason-lspconfig').setup({
      automatic_enable = true,
      ensure_installed = { 'gopls' }
    })
  end,
}
